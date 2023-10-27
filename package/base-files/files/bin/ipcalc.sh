#!/bin/sh

. /lib/functions/ipv4.sh

prog=$(basename "$0")

# wrapper to convert an integer to an address, unless we're using
# decimal output format.
_int2ip() {
    if [ "$decimal" -eq 0 ]; then
        int2ip "$1"
    else
	echo "$1"
    fi
}

usage() {
    echo "Usage: $prog address/prefix [ start limit ]" >&2
    exit 1
}

decimal=0
if [ "$1" = "-d" ]; then
    decimal=1
    shift
fi

if [ $# -eq 0 ]; then
    usage
fi

case "$1" in
*/*.*)
    # data is n.n.n.n/m.m.m.m format, like on a Cisco router
    ipaddr=$(ip2int "${1%/*}")
    netmask=$(ip2int "${1#*/}")
    shift
    ;;
*/*)
    # more modern prefix notation of n.n.n.n/p
    ipaddr=$(ip2int "${1%/*}")
    n=$(check_uint32 "${1#*/}")
    if [ "$n" -gt 32 ]; then
	echo "Prefix out of range ($n)" >&2
	exit 1
    fi
    netmask=$((~((1 << (32 - n)) - 1) & 0xffffffff))
    shift
    ;;
*)
    # address and netmask as two separate arguments
    ipaddr=$(ip2int "$1")
    netmask=$(ip2int "$2")
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
prefix=$((32 - $(bitcount $hostmask)))
broadcast=$((network | hostmask))

count=$((hostmask + 1))

# don't include this-network or broadcast addresses
[ "$prefix" -le 30 ] && count=$((count - 2))

echo "IP=$(_int2ip "$ipaddr")"
echo "NETMASK=$(_int2ip "$netmask")"
[ "$prefix" -le 30 ] && echo "BROADCAST=$(_int2ip "$broadcast")"
echo "NETWORK=$(_int2ip "$network")"
echo "PREFIX=$prefix"
echo "COUNT=$count"

# if there's no range, we're done
[ $# -eq 0 ] && exit 0

if [ "$prefix" -le 30 ]; then
    limit=$((network + 1))
else
    limit="$network"
fi

start=$(check_uint32 "$1")
start=$((network | (start & hostmask)))
[ "$start" -lt "$limit" ] && start="$limit"
[ "$start" -eq "$ipaddr" ] && start=$((ipaddr + 1))

if [ "$prefix" -le 30 ]; then
    limit=$(((network | hostmask) - 1))
else
    limit="$network"
fi

end=$((start + $(check_uint32 "$2") - 1))
[ "$end" -gt "$limit" ] && end="$limit"
[ "$end" -eq "$ipaddr" ] && end=$((ipaddr - 1))

if [ "$start" -gt "$end" ]; then
    echo "network ($(_int2ip "$network")/$prefix) too small" >&2
    exit 1
fi

if [ "$start" -le "$ipaddr" ] && [ "$ipaddr" -le "$end" ]; then
    echo "error: address $ipaddr inside range $start..$end" >&2
    exit 1
fi

echo "START=$(_int2ip "$start")"
echo "END=$(_int2ip "$end")"

exit 0
