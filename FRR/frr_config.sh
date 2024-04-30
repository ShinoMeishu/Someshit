#!/bin/bash
H=$(hostname)
apt install frr -y
#Configuration for Vtysh and ospfd daemon
chmod 777 /etc/frr/daemons
chown frr /etc/frr/daemons
chmod 777 /etc/pam.d/frr
sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons
if [ "$H" == "ISP" ]; then
echo -e "log syslog informational\n\nrouter ospf\n ospf router-id 10.1.1.1\n redistribute connected\n network 10.1.1.0/28 area 0.0.0.0\n network 1.1.1.0/30 area 0.0.0.0\n network 2.2.2.0/30 area 0.0.0.0" > /etc/frr/frr.conf
echo "OSPF set for ISP";
fi;
if [ "$H" == "HQ-R" ]; then
echo -e "router ospf\n ospf router-id 20.1.1.1\n redistribute connected\n network 20.1.1.0/26 area 0.0.0.0\n network 1.1.1.0/30 area 0.0.0.0\n network 3.3.3.0/30 area 0.0.0.0" > /etc/frr/frr.conf
echo "OSPF set for HQ-R";
fi;
if [ "$H" == "BR-R" ]; then
echo -e "router ospf\n ospf router-id 30.1.1.1\n redistribute connected\n network 30.1.1.0/28 area 0.0.0.0\n network 3.3.3.0/30 area 0.0.0.0\n network 2.2.2.0/30 area 0.0.0.0" > /etc/frr/frr.conf
echo "OSPF set for BR-R";
fi;
systemctl restart frr
vtysh -c "show run"
exit 0
