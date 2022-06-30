#!/bin/bash
iface=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')

echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1

# Github bug: https://github.com/ycd/dstp/issues/21
echo net.ipv4.ping_group_range=\"0 0\" >> /etc/sysctl.conf
sysctl -w net.ipv4.ping_group_range="0 0"
chmod g+s /usr/bin/ping
iptables -t nat -A POSTROUTING -o $iface -j MASQUERADE

apt update
apt install wget
wget https://github.com/CloudAceEmma/gcp-nat/raw/main/health-check -O /usr/bin/health-check
chmod +x /usr/bin/health-check

nohup /usr/bin/health-check >/dev/null 2>&1 &
