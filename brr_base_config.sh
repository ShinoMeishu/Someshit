#!/bin/bash
#BR-Router config

#Set ip addresses
INT1="ens33"
INT2="ens36"
ADD1="3.3.3.2/30"
GATE1="3.3.3.1"
ADD2="10.3.3.1/28"

echo -e "source /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "#The loopback network interface\nauto lo\niface lo inet loopback\n" >> /etc/network/interfaces
echo -e "#Subnet ISP-HQ\nauto $INT1\niface $INT1 inet static\naddress $ADD1\ngateway $GATE1\n" >> /etc/network/interfaces
echo -e "#Subnet HQ\nauto $INT2\niface $INT2 inet static\naddress $ADD2"  >> /etc/network/interfaces

echo "Added addresses"

#iptables install, flush and add
apt install iptables -y
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -A POSTROUTING -t nat -j MASQUERADE

echo "iptables configured"

#Ipv4 forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sysctl -p

systemctl restart networking
echo "Addresses, ip tables and ipv4_forwarding configured"
exit 0

