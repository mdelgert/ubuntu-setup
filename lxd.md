https://127.0.0.1:8443
https://canonical.com/lxd/install
https://documentation.ubuntu.com/lxd/stable-5.21/tutorial/first_steps/

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
# Fix connection not working (but fix below is cleaner)
https://stackoverflow.com/questions/78018412/lxd-lxc-container-has-no-external-network-access-debian-12

```bash
sudo iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE 
sudo iptables -A FORWARD -i lxdbr0 -o wlp2s0 -j ACCEPT 
sudo iptables -A FORWARD -i wlp2s0 -o lxdbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
```

# Delete existing broken bridge (if any)
lxc profile device remove default eth0
lxc network delete lxdbr0

# Recreate LXD NAT bridge
lxc network create lxdbr0 \
  ipv4.address=10.101.0.1/24 \
  ipv4.nat=true \
  ipv6.address=none

# Ensure all containers use the default profile with this bridge
lxc profile device add default eth0 nic \
  nictype=bridged \
  parent=lxdbr0 \
  name=eth0
