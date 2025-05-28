# OpenVPN DNS Troubleshooting and Persistent Configuration

sudo apt update
sudo apt install openvpn-systemd-resolved

# Find VPN and all connections config file paths useful
sudo nmcli -f NAME,DEVICE,FILENAME connection show

# Can manually add fix or just run this command
sudo nmcli connection modify "OpenVPN" ipv4.dns-search ~local

# Will need to also apply DnsFix in wireguard folder

# This is for manual config and I could never get working

# DNS support begin "sudo apt install openvpn-systemd-resolved"
script-security 2
up /etc/openvpn/update-systemd-resolved
down /etc/openvpn/update-systemd-resolved
down-pre
dhcp-option DOMAIN-SEARCH local
# DNS support end

## Useful Links
- [openvpn-update-resolv-conf (GitHub)](https://github.com/alfredopalhares/openvpn-update-resolv-conf)
- [OpenVPN Forums: DNS Issues](https://forums.openvpn.net/viewtopic.php?t=22159)
- [ASUS ROG Forum: LAN Access with OpenVPN](https://rog-forum.asus.com/t5/gaming-routers/setting-up-access-to-lan-with-openvpn/td-p/872043)

## Show Tunnel Status
```bash
ip addr show tun0
ifconfig tun0
resolvectl status tun0
```

## Temporarily Append Domain Name for Name Resolution
```bash
sudo resolvectl domain tun0 ~local
```

## Undo Temporary Domain Change
```bash
sudo resolvectl revert tun0
```

## Manually Lookup and Specify DNS Servers
```bash
nslookup device.local 192.168.50.1
```

---

## Persistent DNS Configuration (Recommended)
For persistent DNS settings across reboots or VPN reconnections, configure `/etc/systemd/resolved.conf.d/`.

To make the `~local` domain and DNS server persistent:

1. Create the configuration directory (if it doesn't exist):
   ```bash
   sudo mkdir -p /etc/systemd/resolved.conf.d
   ```
2. Create or edit the VPN DNS config:
   ```bash
   sudo nano /etc/systemd/resolved.conf.d/vpn.conf
   ```
3. Add the following content:
   ```ini
   [Resolve]
   DNS=192.168.50.1
   Domains=~local
   ```
4. Save and exit, then restart systemd-resolved:
   ```bash
   sudo systemctl restart systemd-resolved
   ```

### To Undo Persistent Configuration
Remove the config file and restart the service:
```bash
sudo rm /etc/systemd/resolved.conf.d/vpn.conf
sudo systemctl restart systemd-resolved
```

---

This approach ensures DNS settings are applied automatically, avoiding manual `resolvectl` commands each time.