# Fix connection not working (but fix below is cleaner)
https://stackoverflow.com/questions/78018412/lxd-lxc-container-has-no-external-network-access-debian-12

# Better fix in lxd.md
```bash
sudo iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE 
sudo iptables -A FORWARD -i lxdbr0 -o wlp2s0 -j ACCEPT 
sudo iptables -A FORWARD -i wlp2s0 -o lxdbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
```