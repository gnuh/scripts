clear

#COLOR CONFIG
red='\e[0;31m'
blue='\e[0;34m'
green='\e[0;32m'
NC='\e[00m'
#

echo -e "${blue}Gnuh - MAN IN THE MIDDLE ${red}(URLSNARF, DRIFTNET)${NC}"
iwconfig
read -e -p "Digite a interface: " i
gnome-terminal --zoom=.8 -x urlsnarf -i $i
driftnet -i $i &
