iptables -I INPUT 1 -i wlan0 -p tcp --tcp-flags SYN,RST,ACK SYN --dport 20000 -m conntrack --ctstate NEW -j ACCEPT
iptables -I INPUT 1 -i wlan0 -p udp --dport 20000 -m conntrack --ctstate NEW -j ACCEPT
