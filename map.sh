#GNUH TIPS
clear #limpar tela

#COLOR CONFIG
red='\e[0;31m'
blue='\e[0;34m'
green='\e[0;32m'
NC='\e[0m'
#

#pegar endereço do IP Local
myIP=$(LANG=C /sbin/ifconfig  | sed -ne $'/127.0.0.1/ ! { s/^[ \t]*inet[ \t]\\{1,99\\}\\(addr:\\)\\{0,1\\}\\([0-9.]*\\)[ \t\/].*$/\\2/p; }')

#trocando IP pelo GateWay
set -- "$myIP"
IFS="."; declare -a Array=($*)
myIP="${Array[0]}.${Array[1]}.${Array[2]}.1"
#

#MENSAGEM
echo -e "${blue}Gnuh - Network Mapper ${red}($myIP)${NC}"
echo -e "${green}Carregando...${NC}"
#

#SCANNEAR IPS DO GATEWAY
#nmap -sP -T4 "$myIP"/24 > scan.txt
clear
echo -e "${blue}Gnuh - Network Mapper ${red}($myIP)${NC}"

tput setaf 3;cat scan.txt | grep "Nmap" | cut -d " " -f5,7;tput setaf default

