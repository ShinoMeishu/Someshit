#!/bin/bash
#Show Interface, IPv4, IPv6

NUM=4
#Interface numeration
INT1="ens33"
INT2="ens36"
INT3="ens37"
INT4="ens38"

x=1
while [ $x -le $NUM ]
do
        varname=INT$x
        echo -n "${!varname}: "
        ip -4 addr show ${!varname} | grep -oP '(?<=\binet )[^/]+/\w+|(?<=\binet6 )[^/]+/\w+' | tr -d '\012\015'
        echo -n " "
        ip -6 addr show ${!varname} | grep -Po '(?<=\binet )[^/]+/\w+|(?<=\binet6 )[^/]+/\w+'
        x=$(( x + 1 ))
done
