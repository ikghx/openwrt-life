uint_max=4294967295

# Common error handler
__die() {
    local fmt="$1"
    shift

    printf "$fmt\n" "$@" >&2
    exit 1
}

# check that $1 is only base 10 digits, and that it doesn't
# exceed 2^32-1
assert_uint32() {
    local n="$1"

    if [ -z "$n" -o -n "${n//[0-9]/}" ]; then
	printf "Not a decimal integer (%s)" "$n ">&2
	return 1
    fi

    if [ "$n" -gt $uint_max ]; then
	printf "Out of range (%s)" "$n" >&2
	return 1
    fi

    if [ "$((n + 0))" != "$n" ]; then
	echo "Not normalized notation (%s)" "$n" >&2
	return 1
    fi

    return 0
}

_bitcount() {
    local c="$1"

    c=$((((c >> 1) & 0x55555555) + (c & 0x55555555)))
    c=$((((c >> 2) & 0x33333333) + (c & 0x33333333)))
    c=$((((c >> 4) & 0x0f0f0f0f) + (c & 0x0f0f0f0f)))
    c=$((((c >> 8) & 0x00ff00ff) + (c & 0x00ff00ff)))
    c=$((((c >> 16) & 0x0000ffff) + (c & 0x0000ffff)))

    echo "$c"
}

# return a count of the number of bits set in $1
bitcount() {
    local c="$1"
    assert_uint32 "$c" || exit 1

    _bitcount "$c"
}

# tedious but portable with busybox's limited shell
# we check each octet to be in the range of 0..255,
# and also make sure there's no extaneous characters.
str2ip() {
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
	__die "Not a dotted quad (%s)" "$1"
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
	__die "Not a dotted quad (%s)" "$1"
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
	__die "Not a dotted quad (%s)" "$1"
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
	__die "Not a dotted quad (%s)" "$1"
	;;
    esac

    ret=$((ret + n))

    [ -n "$ip" ] && __die "Not a dotted quad (%s)" "$1"

    echo "$ret"
}

_ip2str() {
    local n="$1"

    echo "$((n >> 24)).$(((n >> 16) & 255)).$(((n >> 8) & 255)).$((n & 255))"
}

# convert back from an integer to dotted-quad.
ip2str() {
    local n="$1"
    assert_uint32 "$n" || exit 1

    _ip2str "$n"
}

_prefix2netmask() {
    local n="$1"

    echo "$(((~(uint_max >> n)) & uint_max))"
}

# convert prefix into an integer bitmask
prefix2netmask() {
    local n="$1"
    assert_uint32 "$n" || exit 1

    [ "$n" -gt 32 ] && __die "Prefix out-of-range (%s)" "$n"

    _prefix2netmask "$n"
}

_is_contiguous() {
    local x="$1"	# no checking done
    local y=$((~x & uint_max))
    local z=$(((y + 1) & uint_max))

    [ $((z & y)) -eq 0 ]
}

# check argument as being contiguous upper bits (and yes,
# 0 doesn't have any discontiguous bits).
is_contiguous() {
    local x="$1"
    assert_uint32 "$x" || exit 1

    _is_contiguous "$x"
}

_netmask2prefix() {
    local n="$1"

    echo "$((32 - $(bitcount $n)))"
}

# convert mask to prefix, validating that it's a conventional
# (contiguous) netmask.
netmask2prefix() {
    local n="$1"
    assert_uint32 "$n" || exit 1

    _is_contiguous "$n" || __die "Not a contiguous netmask (%08x)" "$n"

    _netmask2prefix "$n"
}
