#!/bin/sh

NPROCS="$(grep -c "^processor.*:" /proc/cpuinfo)"
[ "$NPROCS" -gt 1 ] || exit

PROC_MASK="$(( (1 << NPROCS) - 1 ))"

find_irq_cpu() {
        dev="$1"
	    match="$(grep -m 1 "$dev\$" /proc/interrupts)"
	    cpu=0

	[ -n "$match" ] && {
            set -- "$match"
		shift
		for cur in $(seq 1 $NPROCS); do
			[ "$1" -gt 0 ] && {
				cpu=$((cur - 1))
				break
			}
			shift
		done
	}

	echo "$cpu"
}

set_hex_val() {
	file="$1"
	val="$2"
	val="$(printf %x "$val")"
    [ -n "$DEBUG" ] && echo "$file = $val"
	echo "$val" > "$file"
}

packet_steering="$(uci get "network.@globals[0].packet_steering")"
[ "$packet_steering" != 1 ] && exit 0

exec 9>/var/lock/smp_tune.lock
flock 9 || exit 1

[ -e "/usr/libexec/platform/packet-steering.sh" ] && {
    /usr/libexec/platform/packet-steering.sh
	exit 0
}

for dev in /sys/class/net/*; do
    [ -d "$dev" ] || continue

    # ignore virtual interfaces
    for file in "${dev}"/lower_*; do
    if [ -e "$file" ]; then continue
        fi
    done
        
	[ -d "${dev}/device" ] || continue

	device="$(readlink "${dev}/device")"
	device="$(basename "$device")"
	irq_cpu="$(find_irq_cpu "$device")"
	irq_cpu="$((1 << irq_cpu))"

	for q in "${dev}"/queues/tx-*; do
	    set_hex_val "$q/xps_cpus" "$PROC_MASK"
	done

    # ignore dsa slave ports for RPS
	subsys="$(readlink "${dev}/device/subsystem")"
	subsys="$(basename "$subsys")"
	[ "$subsys" = "mdio_bus" ] && continue

	for q in "${dev}"/queues/rx-*; do
	    set_hex_val "$q/rps_cpus" "$PROC_MASK"
	done
done
