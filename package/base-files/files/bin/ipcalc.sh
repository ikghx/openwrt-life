#!/bin/sh

. /lib/functions/ipv4.sh

PROG="$(basename "$0")"

# wrapper to convert an integer to an address, unless we're using
# decimal output format.
# override library function
ip2str() {
    local n="$1"
    assert_uint32 "$n" || exit 1

    if [ "$decimal" -ne 0 ]; then
	echo "$1"
    elif [ "$hexadecimal" -ne 0 ]; then
	printf "%x\n" "$1"
    else
        _ip2str "$1"
    fi
}

usage() {
    echo "Usage: $PROG [ -d | -x ] address/prefix [ start limit ]" >&2
    exit 1
}

decimal=0
hexadecimal=0
if [ "$1" = "-d" ]; then
    decimal=1
    shift
elif [ "$1" = "-x" ]; then
    hexadecimal=1
    shift
fi

if [ $# -eq 0 ]; then
    usage
fi

case "$1" in
*/*.*)
    # data is n.n.n.n/m.m.m.m format, like on a Cisco router
    ipaddr="$(str2ip "${1%/*}")" || exit 1
    netmask="$(str2ip "${1#*/}")" || exit 1
    prefix="$(netmask2prefix "$netmask")" || exit 1
    shift
    ;;
*/*)
    # more modern prefix notation of n.n.n.n/p
    ipaddr="$(str2ip "${1%/*}")" || exit 1
    prefix="${1#*/}"
    netmask="$(prefix2netmask "$prefix")" || exit 1
    shift
    ;;
*)
    # address and netmask as two separate arguments
    ipaddr="$(str2ip "$1")" || exit 1
    netmask="$(str2ip "$2")" || exit 1
    prefix="$(netmask2prefix "$netmask")" || exit 1
    shift 2
    ;;
esac

# we either have no arguments left, or we have a range start and length
if [ $# -ne 0 ] && [ $# -ne 2 ]; then
    usage
fi

# complement of the netmask, i.e. the hostmask
hostmask=$((netmask ^ 0xffffffff))

network=$((ipaddr & netmask))
broadcast=$((network | hostmask))

count=$((hostmask + 1))

# don't include this-network or broadcast addresses
[ "$prefix" -le 30 ] && count=$((count - 2))

echo "IP=$(ip2str "$ipaddr")"
echo "NETMASK=$(ip2str "$netmask")"
[ "$prefix" -le 30 ] && echo "BROADCAST=$(ip2str "$broadcast")"
echo "NETWORK=$(ip2str "$network")"
echo "PREFIX=$prefix"
echo "COUNT=$count"

# if there's no range, we're done
[ $# -eq 0 ] && exit 0

if [ "$prefix" -le 30 ]; then
    lower=$((network + 1))
else
    lower="$network"
fi

start="$1"
assert_uint32 "$start" || exit 1
start=$((network | (start & hostmask))) || exit 1
[ "$start" -lt "$lower" ] && start="$lower"
[ "$start" -eq "$ipaddr" ] && start=$((start + 1))

if [ "$prefix" -le 30 ]; then
    upper=$(((network | hostmask) - 1))
else
    upper="$network"
fi

range="$2"
assert_uint32 "$range" || exit 1
end=$((start + range - 1))
[ "$end" -gt "$upper" ] && end="$upper"
[ "$end" -eq "$ipaddr" ] && end=$((end - 1))

if [ "$start" -gt "$end" ]; then
    echo "network ($(ip2str "$network")/$prefix) too small" >&2
    exit 1
fi

if [ "$start" -le "$ipaddr" ] && [ "$ipaddr" -le "$end" ]; then
    echo "error: address $ipaddr inside range $start..$end" >&2
    exit 1
fi

echo "START=$(ip2str "$start")"
echo "END=$(ip2str "$end")"

exit 0
