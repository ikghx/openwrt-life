uint_max=4294967295

# return a count of the number of bits set in $1
bitcount() {
    local c="$1"

    c=$((((c >> 1) & 0x55555555) + (c & 0x55555555)))
    c=$((((c >> 2) & 0x33333333) + (c & 0x33333333)))
    c=$((((c >> 4) & 0x0f0f0f0f) + (c & 0x0f0f0f0f)))
    c=$((((c >> 8) & 0x00ff00ff) + (c & 0x00ff00ff)))
    c=$((((c >> 16) & 0x0000ffff) + (c & 0x0000ffff)))

    echo "$c"
}

# check that $1 is only base 10 digits, and that it doesn't
# exceed 2^32-1
check_uint32() {
    local n="$1"

    if [ -n "${n//[0-9]/}" ]; then
	echo "Not a decimal integer ($n)" >&2
	exit 1
    fi

    if [ "$n" -gt $uint_max ]; then
	echo "Out of range ($n)" >&2
	exit 1
    fi

    echo "$n"
}

# tedious but portable with busybox's limited shell
# we check each octet to be in the range of 0..255,
# and also make sure there's no extaneous characters
# after the last octet.
ip2int() {
    local ip="$1" n ret=0

    case "$ip" in
    [0-9].*)
	n="${ip:0:1}"
	ip="${ip:2}"
	;;
    [1-9][0-9].*)
	n="${ip:0:2}"
	ip="${ip:3}"
	;;
    1[0-9][0-9].*|2[0-4][0-9].*|25[0-5].*)
	n="${ip:0:3}"
	ip="${ip:4}"
	;;
    *)
	echo "Not a dotted quad ($1)" >&2
	exit 1
	;;
    esac

    ret=$((n << 24))

    case "$ip" in
    [0-9].*)
	n="${ip:0:1}"
	ip="${ip:2}"
	;;
    [1-9][0-9].*)
	n="${ip:0:2}"
	ip="${ip:3}"
	;;
    1[0-9][0-9].*|2[0-4][0-9].*|25[0-5].*)
	n="${ip:0:3}"
	ip="${ip:4}"
	;;
    *)
	echo "Not a dotted quad ($1)" >&2
	exit 1
	;;
    esac

    ret=$((ret + (n << 16)))

    case "$ip" in
    [0-9].*)
	n="${ip:0:1}"
	ip="${ip:2}"
	;;
    [1-9][0-9].*)
	n="${ip:0:2}"
	ip="${ip:3}"
	;;
    1[0-9][0-9].*|2[0-4][0-9].*|25[0-5].*)
	n="${ip:0:3}"
	ip="${ip:4}"
	;;
    *)
	echo "Not a dotted quad ($1)" >&2
	exit 1
	;;
    esac

    ret=$((ret + (n << 8)))

    case "$ip" in
    [0-9])
	n="${ip:0:1}"
	ip="${ip:1}"
	;;
    [1-9][0-9])
	n="${ip:0:2}"
	ip="${ip:2}"
	;;
    1[0-9][0-9]|2[0-4][0-9]|25[0-5])
	n="${ip:0:3}"
	ip="${ip:3}"
	;;
    *)
	echo "Not a dotted quad." >&2
	exit 1
	;;
    esac

    ret=$((ret + n))

    if [ -n "$ip" ]; then
	echo "Not a dotted quad ($1)" >&2
	exit 1
    fi

    echo "$ret"
}

# convert back from an integer to dotted-quad.
int2ip() {
    local n="$1"

    echo "$((n >> 24)).$(((n >> 16) & 255)).$(((n >> 8) & 255)).$((n & 255))"
}
