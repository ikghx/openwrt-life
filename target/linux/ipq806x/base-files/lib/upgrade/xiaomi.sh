# SPDX-License-Identifier: GPL-2.0-or-later OR MIT

. /lib/functions.sh

MAGIC_XIAOMI_HDR1="48445231"     # "HDR1" - xiaomi image header
MAGIC_XIAOMI_BLK="beba0000"
MAGIC_UIMAGE="27051956"          # uImage header
MAGIC_UBI="55424923"             # "UBI#"
MAGIC_UBIFS="31181006"
MAGIC_HSQS="68737173"            # "hsqs"
MAGIC_SYSUPG="7379737570677261"  # TAR "sysupgrade"

XIAOMI_PAGESIZE=2048

XIAOMI_FW_FILE=""
XIAOMI_FW_SIZE=0
XIAOMI_KERNEL_PART=$CI_KERNPART
XIAOMI_KERNEL2_PART=""
XIAOMI_KERNEL2_NAMES="kernel_stock|kernel_dup"
XIAOMI_ROOTFS_PART=$CI_UBIPART
XIAOMI_ROOTFS_PARTSIZE=

XIAOMI_RESTORE_ROOTFS2=

log_msg() {
	echo "$@"
}

log_err() {
	echo "ERROR: $@" >&2
}

die() {
	log_err "$@"
	exit 1
}

get_uint32_at() {
	local offset=$1
	local endianness=$2
	local hex
	if [ $(( $offset + 4 )) -gt $XIAOMI_FW_SIZE ]; then
		echo ""
		return
	fi
	local dd_args="if=$XIAOMI_FW_FILE skip=$offset bs=1 count=4"
	if [ "$endianness" = "be" ]; then
		hex=$( dd $dd_args 2>/dev/null | hexdump -v -n 4 -e '1/1 "%02x"' )
	else
		hex=$( dd $dd_args 2>/dev/null | hexdump -v -e '1/4 "%02x"' )
	fi
	echo $( printf "%d" 0x$hex )
}

get_hexdump_at() {
	local offset=$1
	local size=$2
	if [ $(( $offset + $size )) -gt $XIAOMI_FW_SIZE ]; then
		echo ""
		return
	fi
	local dd_args="if=$XIAOMI_FW_FILE skip=$offset bs=1 count=$size"
	echo $( dd $dd_args 2>/dev/null | hexdump -v -n $size -e '1/1 "%02x"' )
}

get_round_up() {
	local value=$1
	local base=$2
	local pad=0
	if [ -z "$base" ]; then
		base=$XIAOMI_PAGESIZE
	else
		base=$( printf "%d" $base )
	fi
	if [ $(( $value % $base )) != 0 ]; then
		pad=$(( $base - $value % $base ))
	fi
	echo $(( $value + $pad ))
}

get_part_size() {
	local part_name=$1
	local part=$( cat /proc/mtd | grep \"$part_name\" )
	if [ -z "$part" ]; then
		echo 0
	else
		local mtd_size_hex=$( echo $part | awk '{print "0x"$2}' )
		echo $( printf "%d" $mtd_size_hex )
	fi
}

xiaomi_check_sizes() {
	local part_name=$1
	local img_offset=$2
	local img_size=$3

	local mtd_size=$( get_part_size $part_name )
	if [ "$mtd_size" = "0" ]; then
		echo "cannot find mtd partition with name '$part_name'"
		return 1
	fi
	local img_end=$(( $img_offset + $img_size ))
	if [ $img_end -gt $XIAOMI_FW_SIZE ]; then
		echo "incorrect image size (part: '$part_name')"
		return 1
	fi
	if [ $img_size -gt $mtd_size ]; then
		echo "image is greater than partition '$part_name'"
		return 1
	fi
	echo ""
	return 0
}

xiaomi_mtd_write() {
	local part_name=$1
	local img_offset=$2
	local img_size=$3
	local part_skip=$4

	img_size=$( get_round_up $img_size )
	local err=$( xiaomi_check_sizes $part_name $img_offset $img_size )
	if [ -n "$err" ]; then
		log_err $err
		return 1
	fi
	if [ -n "$part_skip" ]; then
		part_skip="-p $part_skip"
	fi
	local count=$(( $img_size / $XIAOMI_PAGESIZE ))
	local dd_args="if=$XIAOMI_FW_FILE iflag=skip_bytes skip=$img_offset bs=$XIAOMI_PAGESIZE count=$count"
	dd $dd_args | mtd -f $part_skip write - "$part_name" || {
		log_err "Failed to flash '$part_name'"
		return 1
	}
	return 0
}

xiaomi_flash_images() {
	local kernel_offset=$1
	local kernel_size=$2
	local rootfs_offset=$3
	local rootfs_size=$4
	local err
	local part_skip=0

	kernel_size=$( get_round_up $kernel_size )
	rootfs_size=$( get_round_up $rootfs_size )

	err=$( xiaomi_check_sizes $XIAOMI_KERNEL_PART $kernel_offset $kernel_size )
	[ -n "$err" ] && { log_err $err; return 1; }

	if [ -n "$XIAOMI_KERNEL2_PART" ]; then
		err=$( xiaomi_check_sizes $XIAOMI_KERNEL2_PART $kernel_offset $kernel_size )
		[ -n "$err" ] && { log_err $err; return 1; }
	fi

	err=$( xiaomi_check_sizes $XIAOMI_ROOTFS_PART $rootfs_offset $rootfs_size )
	[ -n "$err" ] && { log_err $err; return 1; }

	if [ "$XIAOMI_RESTORE_ROOTFS2" = "true" -a -n "$XIAOMI_ROOTFS_PARTSIZE" ]; then
		part_skip=$( printf "%d" $XIAOMI_ROOTFS_PARTSIZE )
		if [ $part_skip -lt 1000000 ]; then
			part_skip=0
		fi
	fi

	if [ $part_skip -gt 0 ]; then
		local ksize=$(( $part_skip + $rootfs_size ))
		local mtd_size=$( get_part_size $XIAOMI_ROOTFS_PART )
		if [ $ksize -gt $mtd_size ]; then
			log_err "double rootfs is greater than partition '$XIAOMI_ROOTFS_PART'"
			return 1
		fi
	fi

	mtd erase "$XIAOMI_ROOTFS_PART" || {
		log_err "Failed to erase partition '$part_name'"
		return 1
	}

	xiaomi_mtd_write $XIAOMI_KERNEL_PART $kernel_offset $kernel_size || {
		log_err "Failed flash data to '$XIAOMI_KERNEL_PART' partition"
		return 1
	}
	log_msg "Kernel image flashed to '$XIAOMI_KERNEL_PART'"

	if [ -n "$XIAOMI_KERNEL2_PART" ]; then
		xiaomi_mtd_write $XIAOMI_KERNEL2_PART $kernel_offset $kernel_size || {
			log_err "Failed flash data to '$XIAOMI_KERNEL2_PART' partition"
			return 1
		}
		log_msg "Kernel image flashed to '$XIAOMI_KERNEL2_PART'"
	fi

	xiaomi_mtd_write $XIAOMI_ROOTFS_PART $rootfs_offset $rootfs_size || {
		log_err "Failed flash data to '$XIAOMI_ROOTFS_PART' partition"
		return 1
	}
	log_msg "Rootfs image flashed to '$XIAOMI_ROOTFS_PART'!"

	if [ $part_skip -gt 0 ]; then
		xiaomi_mtd_write $XIAOMI_ROOTFS_PART $rootfs_offset $rootfs_size $part_skip || {
			log_err "Failed flash data to '$XIAOMI_ROOTFS_PART' partition (2)"
			return 1
		}
		log_msg "Rootfs image flashed to '$XIAOMI_ROOTFS_PART':$XIAOMI_ROOTFS_PARTSIZE"
	fi

	log_msg "Firmware write successful! Reboot..."
	sync
	umount -a
	reboot -f
	exit 0
}

check_ubi_header() {
	local offset=$1

	local magic=$( get_hexdump_at $offset 4 )
	[ "$magic" != $MAGIC_UBI ] && { echo ""; return 1; }

	local magic_ubi2="55424921"  # "UBI!"
	offset=$(( $offset + $XIAOMI_PAGESIZE ))
	magic=$( get_hexdump_at $offset 4 )
	[ "$magic" != $magic_ubi2 ] && { echo ""; return 1; }

	echo "true"
	return 0
}

get_rootfs_offset() {
	local start=$1
	local pos  offset  align  end

	for offset in 0 1 2 3 4; do
		pos=$(( $start + $offset ))
		[ -n "$( check_ubi_header $pos )" ] && { echo $pos; return 0; }
	done

	for align in 4 8 16 32 64 128 256 512 1024 2048 4096; do
		pos=$( get_round_up $start $align )
		[ -n "$( check_ubi_header $pos )" ] && { echo $pos; return 0; }
	done

	align=65536
	pos=$( get_round_up $start $align )
	end=$(( $pos + 3000000 ))
	while true; do
		[ $(( $pos + 150000 )) -gt $XIAOMI_FW_SIZE ] && break
		[ -n "$( check_ubi_header $pos )" ] && { echo $pos; return 0; }
		pos=$(( $pos + $align ))
		[ $pos -ge $end ] && break
	done

	echo ""
	return 1
}

xiaomi_do_factory_upgrade() {
	local err
	local magic
	local kernel_offset  kernel_size
	local rootfs_offset  rootfs_size

	local kernel_mtd="$( find_mtd_index $XIAOMI_KERNEL_PART )"
	if [ -z "$kernel_mtd" ]; then
		log_err "partition '$XIAOMI_KERNEL_PART' not found"
		return 1
	fi
	log_msg "Forced factory upgrade..."

	kernel_offset=0
	kernel_size=$( get_uint32_at 12 "be" )
	kernel_size=$(( $kernel_size + 64 ))

	rootfs_offset=$( get_rootfs_offset $kernel_size )
	if [ -z "$rootfs_offset" ]; then
		log_err "can't find ubinized rootfs in the firmware image"
		return 1
	fi
	rootfs_size=$(( $XIAOMI_FW_SIZE - $rootfs_offset ))
	local rootfs_end=$(( $rootfs_offset + $rootfs_size ))

	XIAOMI_RESTORE_ROOTFS2=false
	xiaomi_flash_images $kernel_offset $kernel_size $rootfs_offset $rootfs_size || {
		log_err "can't flash factory image"
		return 1
	}
	exit 0
}

xiaomi_do_revert_stock() {
	local err
	local magic
	local blk  blkpos  blk_magic  offset  file_size
	local kernel_offset
	local kernel_size=0
	local rootfs_offset
	local rootfs_size=0

	local kernel_mtd=$( find_mtd_index $XIAOMI_KERNEL_PART )
	if [ -z "$kernel_mtd" ]; then
		log_err "partition '$XIAOMI_KERNEL_PART' not found"
		return 1
	fi
	log_msg "Forced revert to stock firmware..."

	for blk in 16 20 24 28 32 36; do
		blkpos=$( get_uint32_at $blk )
		[ -z "$blkpos" ] && continue
		[ $blkpos -lt 48 ] && continue
		blk_magic=$( get_hexdump_at $blkpos 4 )
		[ "$blk_magic" != $MAGIC_XIAOMI_BLK ] && continue
		offset=$(( $blkpos + 8 ))
		file_size=$( get_uint32_at $offset 4 )
		[ -z "$file_size" ] && continue
		[ $file_size -lt 1000000 ] && continue
		offset=$(( $blkpos + 48 ))
		magic=$( get_hexdump_at $offset 4 )
		if [ "$magic" = $MAGIC_UIMAGE ]; then
			kernel_size=$file_size
			kernel_offset=$offset
		fi
		if [ "$magic" = $MAGIC_UBI -o "$magic" = $MAGIC_HSQS ]; then
			rootfs_size=$file_size
			rootfs_offset=$offset
		fi
	done
	if [ $kernel_size -eq 0 ]; then
		log_err "incorrect stock firmware image (kernel not found)"
		return 1
	fi
	if [ $rootfs_size -eq 0 ]; then
		log_err "incorrect stock firmware image (rootfs not found)"
		return 1
	fi

	XIAOMI_RESTORE_ROOTFS2=true
	xiaomi_flash_images $kernel_offset $kernel_size $rootfs_offset $rootfs_size || {
		log_err "ERROR: can't revert to stock firmware"
		return 1
	}
	exit 0
}

platform_do_upgrade_xiaomi() {
	XIAOMI_FW_FILE=$1
	local stock_rootfs_size=$2
	local magic
	local kernel_mtd  kernel2_mtd  rootfs_mtd
	local kernel2_part_list  part_name

	XIAOMI_FW_SIZE=$( wc -c "$XIAOMI_FW_FILE" 2> /dev/null | awk '{print $1}' )
	if [ -z "$XIAOMI_FW_SIZE" ]; then
		log_err "File '$XIAOMI_FW_FILE' not found!"
		exit 1
	fi
	if [ $XIAOMI_FW_SIZE -lt 1000000 ]; then
		log_err "file '$XIAOMI_FW_FILE' is incorrect"
		exit 1
	fi

	kernel_mtd=$( find_mtd_index $XIAOMI_KERNEL_PART )
	if [ -z "$kernel_mtd" ]; then
		log_err "cannot find mtd partition for '$XIAOMI_KERNEL_PART'"
		exit 1
	fi
	kernel2_part_list=$( echo "$XIAOMI_KERNEL2_NAMES" | sed 's/|/\n/g' )
	for part_name in $kernel2_part_list; do
		kernel2_mtd=$( find_mtd_index $part_name )
		if [ -n "$kernel2_mtd" ]; then
			XIAOMI_KERNEL2_PART="$part_name"
			log_msg "Found alt kernel partition '$XIAOMI_KERNEL2_PART'"
			break
		fi
	done
	rootfs_mtd=$( find_mtd_index $XIAOMI_ROOTFS_PART )
	if [ -z "$rootfs_mtd" ]; then
		log_err "cannot find mtd partition for '$XIAOMI_ROOTFS_PART'"
		exit 1
	fi

	magic=$( get_hexdump_at 0 4 )

	# Flash factory image (uImage header)
	if [ "$magic" = $MAGIC_UIMAGE ]; then
		xiaomi_do_factory_upgrade
		exit $?
	fi

	# Revert to stock firmware ("HDR1" header)
	if [ "$magic" = $MAGIC_XIAOMI_HDR1 ]; then
		if [ -n "$stock_rootfs_size" ]; then
			XIAOMI_ROOTFS_PARTSIZE=$stock_rootfs_size
		fi
		xiaomi_do_revert_stock
		exit $?
	fi

	magic=$( get_hexdump_at 0 8 )
	if [ "$magic" != $MAGIC_SYSUPG ]; then
		log_err "incorrect image for system upgrading!"
		exit 1
	fi
	log_msg "SysUpgrade start..."
	local tar_file=$XIAOMI_FW_FILE
	local board_dir=$( tar tf $tar_file | grep -m 1 '^sysupgrade-.*/$' )
	[ -z "$board_dir" ] && {
		log_err "board dir not found"
		exit 1
	}
	board_dir=${board_dir%/}

	local control_len=$( (tar xf $tar_file $board_dir/CONTROL -O | wc -c) 2> /dev/null)
	if [ $control_len -lt 3 ]; then
		log_err "incorrect stock firmware image (CONTROL not found)"
		exit 1
	fi
	local kernel_len=$( (tar xf $tar_file $board_dir/kernel -O | wc -c) 2> /dev/null)
	if [ $kernel_len -lt 1000000 ]; then
		log_err "incorrect stock firmware image (kernel not found)"
		exit 1
	fi
	local rootfs_len=$( (tar xf $tar_file $board_dir/root -O | wc -c) 2> /dev/null)
	if [ $rootfs_len -lt 1000000 ]; then
		log_err "incorrect stock firmware image (rootfs not found)"
		exit 1
	fi

	if [ -n "$XIAOMI_KERNEL2_PART" ]; then
		tar Oxf $tar_file $board_dir/kernel | mtd -f write - $XIAOMI_KERNEL2_PART && {
			log_msg "Kernel image flashed to '$XIAOMI_KERNEL2_PART'"
		} || {
			log_err "cannot flash partition '$XIAOMI_KERNEL2_PART'"
			exit 1
		}
	fi

	nand_do_upgrade "$XIAOMI_FW_FILE"
}
