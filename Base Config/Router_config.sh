#!/bin/bash
#Base config
H=$(hostname)
NUM=0
#Interface numeration
INT1="ens33"
INT2="ens36"
INT3="ens37"
INT4="ens38"

NET1="10.1.1"
NET2="10.2.2"
NET3="10.3.3"
NET12="1.1.1"
NET13="2.2.2"
NET23="3.3.3"

if [ "$H" == "ISP" ]; then
echo -e "source /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "#The loopback network interface\nauto lo\niface lo inet loopback\n" >> /etc/network/interfaces
echo -e "#Internet access interface\nauto $INT1\niface $INT1 inet dhcp\n" >> /etc/network/interfaces
echo -e "#Subnet Internet \nauto $INT2 \niface $INT2 inet static \naddress $NET1.1/28 \n" >> /etc/network/interfaces
echo -e "#Subnet ISP-HQ\nauto $INT3\niface $INT3 inet static\naddress $NET12.1/30 \n" >> /etc/network/interfaces
echo -e "#Subnet ISP-BR\nauto $INT4\niface $INT4 inet static\naddress $NET13.1/30"  >> /etc/network/interfaces
NUM=4
echo "Added addresses for ISP Router";
fi;

if [ "$H" == "HQ-R" ]; then
echo -e "source /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "#The loopback network interface\nauto lo\niface lo inet loopback\n" >> /etc/network/interfaces
echo -e "#Subnet ISP-HQ\nauto $INT1\niface $INT1 inet static\naddress $NET12.2/30\ngateway $NET12.1\n" >> /etc/network/interfaces
echo -e "#Subnet HQ-BR\nauto $INT2\niface $INT2 inet static\naddress $NET23.1/30\n" >> /etc/network/interfaces
echo -e "#Subnet HQ\nauto $INT3\niface $INT3 inet static\naddress $NET2.1/26"  >> /etc/network/interfaces
NUM=3
echo "Added addresses for HQ Router";
fi;

if [ "$H" == "BR-R" ]; then
echo -e "source /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "#The loopback network interface\nauto lo\niface lo inet loopback\n" >> /etc/network/interfaces
echo -e "#Subnet ISP-BR\nauto $INT1\niface $INT1 inet static\naddress $NET13.2/30\ngateway $NET13.1\n" >> /etc/network/interfaces
echo -e "#Subnet HQ-BR\nauto $INT2\niface $INT2 inet static\naddress $NET23.2/30\n" >> /etc/network/interfaces
echo -e "#Subnet BR\nauto $INT3\niface $INT3 inet static\naddress $NET3.1/28"  >> /etc/network/interfaces
NUM=3
echo "Added addresses for BR Router";
fi;

#iptables install, flush and add
apt install iptables -y
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -A POSTROUTING -t nat -j MASQUERADE

#Save iptables config
sudo apt install iptables-persistent -y
echo "iptables configured"

#Ipv4 forwarding
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf
echo "Ipv4_forwarding configured"
systemctl restart networking

#Printing info
echo -e "Config completed\n\n\nIPv4 forwarding:"
sudo sysctl -p
echo -e "\n\n\nInterfaces settings:"
cat /etc/network/interfaces
echo ""
x=1
while [ $x -le $NUM ]
do
        varname=INT$x
        echo -n "${!varname}: "
        ip -4 addr show ${!varname} | grep -oP '(?<=\binet )[^/]+/\w+|(?<=\binet6 )[^/]+/\w+'
        x=$(( x + 1 ))
done


echo -e "\n\n\nIptable:"
sudo iptables -t nat -L

exit 0

