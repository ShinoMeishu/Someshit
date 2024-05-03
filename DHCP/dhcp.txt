apt install isc-dhcp-server
nano /etc/default/isc-dhcp-server 
INTERFACESv4=" ИНТЕРФЕЙС ПОДСЕТИ "

default-lease-time 600;
max-lease-time 7200;
default-lease-time 600;
max-lease-time 7200;
option domain-name "hq.work";
option domain-name-servers 20.20.20.2, 8.8.8.8;
subnet 20.20.20.0 netmask 255.255.255.192 {
 range 20.20.20.2 20.20.20.18;
 option routers 20.20.20.1;
}

host hqserver {
 hardware ethernet MAC-адресс HQ-SRV;
 fixed-address 20.20.20.2;
}

systemctl restart isc-dhcp-server

Изменить HQ-SRV на получение адреса по DHCP
