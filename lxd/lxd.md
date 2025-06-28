https://127.0.0.1:8443
https://canonical.com/lxd/install
https://documentation.ubuntu.com/lxd/stable-5.21/tutorial/first_steps/

# Grant user permissions
```bash
sudo usermod -aG lxd "$USER"
newgrp lxd
getent group lxd | grep "$USER"
```

# Delete existing broken bridge (if any)
```bash
lxc profile device remove default eth0
lxc network delete lxdbr0
```

# Recreate LXD NAT bridge
```bash
lxc network create lxdbr0 \
ipv4.address=10.101.0.1/24 \
ipv4.nat=true \
ipv6.address=none
```

# Ensure all containers use the default profile with this bridge
```bash
lxc profile device add default eth0 nic \
nictype=bridged \
parent=lxdbr0 \
name=eth0
```

# Enable port forward permently
```bash
echo "net.ipv4.ip_forward=1" | sudo tee /etc/sysctl.d/99-lxd.conf
sudo sysctl --system
reboot
```

# Create an instance
```bash
lxc launch ubuntu:24.04 u1
lxc exec u1 -- apt-get update
lxc exec u1 -- passwd
lxc console u1
```

# Delete an instance
```bash
lxc stop u1
lxc delete u1
```