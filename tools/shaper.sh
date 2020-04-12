#!/bin/bash
## Usage: shaper.sh ARG1 ARG2
##
## Example: shaper.sh enp1s0 8Mbit
##
## Purpose: This script will use Traffic Control (tc) to throttle packets destined
##          for the internet. It will detect LAN traffic and mark with 0xb
##          and mark WAN traffic with 0xc. These marks then correspond to two 
##          Traffic Control classes.
##
## Notes:
## ARG1 should be the outgoing network interface of this machine
## ARG2 should be the upload bandwith limit (ie: 1Mbit, 4Mbit, 1Gbit, etc)
##
## Author: Chris Featherstone
## Last Modified: Apr 12 2020

private_block_a=10.0.0.0/8
private_block_b=172.16.0.0/12
private_block_c=192.168.0.0/16
device=$1
inet_up=$2
inet_burst=16k

# are we root?
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# clean up old queues
echo "clear old tc rules"
tc qdisc del dev $device root 2> /dev/null

# clean up old iptables rules (in case this gets run multiple times)

# destination LAN
iptables -D POSTROUTING -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_a} -d ${private_block_a} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_a} -d ${private_block_b} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_a} -d ${private_block_c} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_b} -d ${private_block_a} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_b} -d ${private_block_b} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_b} -d ${private_block_c} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_c} -d ${private_block_a} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_c} -d ${private_block_b} -t mangle -j LANBOUND
iptables -D POSTROUTING -s ${private_block_c} -d ${private_block_c} -t mangle -j LANBOUND

# destination WAN
iptables -D POSTROUTING -s ${private_block_a} ! -d ${private_block_a} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_a} ! -d ${private_block_b} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_a} ! -d ${private_block_c} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_b} ! -d ${private_block_a} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_b} ! -d ${private_block_b} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_b} ! -d ${private_block_c} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_c} ! -d ${private_block_a} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_c} ! -d ${private_block_b} -t mangle -j WANBOUND
iptables -D POSTROUTING -s ${private_block_c} ! -d ${private_block_c} -t mangle -j WANBOUND

# delete chains
iptables -t mangle -F WANBOUND
iptables -t mangle -F LANBOUND
iptables -t mangle -X LANBOUND
iptables -t mangle -X WANBOUND

# create traffic control stuff
echo "create new root queue"
tc qdisc add dev ${device} root handle 1: htb default 13
tc class add dev ${device} parent 1: classid 1:1 htb rate 1000mbit ceil 1000mbit

echo "create 2 buckets"
tc class add dev ${device} parent 1:1 classid 11 htb rate 500Mbit ceil 1000Mbit
tc class add dev ${device} parent 1:1 classid 12 htb rate ${inet_up} burst ${inet_burst}

echo "create 2 filters"
tc filter add dev ${device} parent 1:0 prio 0 protocol ip handle 11 fw flowid 1:11
tc filter add dev ${device} parent 1:0 prio 1 protocol ip handle 12 fw flowid 1:12

# mark lan traffic with 11 and internet bound traffic with 12
echo "mark lan traffic with 11 and internet bound traffic with 12"

# destination WAN
iptables -t mangle -N WANBOUND
iptables -t mangle -A WANBOUND -j MARK --set-mark 12 # 0xc
#iptables -t mangle -A WANBOUND -j LOG --log-prefix "WAN: "
iptables -t mangle -A WANBOUND -j ACCEPT

# destination LAN
iptables -t mangle -N LANBOUND
iptables -t mangle -A LANBOUND -j MARK --set-mark 11 # 0xb
iptables -t mangle -A LANBOUND -j ACCEPT

iptables -I POSTROUTING -t mangle -j WANBOUND
iptables -I POSTROUTING -s ${private_block_a} -d ${private_block_a} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_a} -d ${private_block_b} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_a} -d ${private_block_c} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_b} -d ${private_block_a} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_b} -d ${private_block_b} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_b} -d ${private_block_c} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_c} -d ${private_block_a} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_c} -d ${private_block_b} -t mangle -j LANBOUND
iptables -I POSTROUTING -s ${private_block_c} -d ${private_block_c} -t mangle -j LANBOUND

