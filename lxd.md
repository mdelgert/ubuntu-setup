https://127.0.0.1:8443
https://canonical.com/lxd/install
https://documentation.ubuntu.com/lxd/stable-5.21/tutorial/first_steps/

# Fix connection not working
https://stackoverflow.com/questions/78018412/lxd-lxc-container-has-no-external-network-access-debian-12

iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE 
iptables -A FORWARD -i lxdbr0 -o wlp2s0 -j ACCEPT 
iptables -A FORWARD -i wlp2s0 -o lxdbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Grant user permissions
```bash
sudo usermod -aG lxd "$USER"
newgrp lxd
getent group lxd | grep "$USER"
```

# Create an instance
```bash
lxc launch ubuntu:24.04 ubuntu-container
lxc console ubuntu-container
```