#!/bin/bash
#ISP-Router config

#Set ip addresses

INT1="ens33"
INT2="ens36"
INT3="ens37"
INT4="ens38"
ADD1="1.1.1.1/30"
ADD2="2.2.2.1/30"
ADD3="3.3.3.1/30"

echo -e "source /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "#The loopback network interface\nauto lo\niface lo inet loopback\n" >> /etc/network/interfaces
echo -e "#Internet access interface\nauto $INT1\niface $INT1 inet dhcp\n" >> /etc/network/interfaces
echo -e "#Subnet Internet \nauto $INT2 \niface $INT2 inet static \naddress $ADD1 \n" >> /etc/network/interfaces
echo -e "#Subnet ISP-HQ\nauto $INT3\niface $INT3 inet static\naddress $ADD2 \n" >> /etc/network/interfaces
echo -e "#Subnet ISP-BR\nauto $INT4\niface $INT4 inet static\naddress $ADD3"  >> /etc/network/interfaces

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

