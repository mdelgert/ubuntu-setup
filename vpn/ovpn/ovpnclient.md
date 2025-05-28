
````markdown
# OpenVPN Client on Ubuntu (Command Line with DNS and Script Support)

This guide walks you through configuring and using OpenVPN entirely via the terminal on Ubuntu. It includes instructions to:

- Install required packages
- Configure DNS resolution (especially `.local` domains)
- Use `up` and `down` scripts
- Connect/disconnect manually

---

## ✅ 1. Install Required Packages

```bash
sudo apt update
sudo apt install openvpn openvpn-systemd-resolved -y
````

---

## ✅ 2. Verify systemd-resolved Is Active

```bash
systemctl status systemd-resolved
```

If not running:

```bash
sudo systemctl enable --now systemd-resolved
```

Ensure `/etc/resolv.conf` is a symlink:

```bash
ls -l /etc/resolv.conf
```

Should output:

```
/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf
```

If not, fix it:

```bash
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

---

## ✅ 3. Update Your OpenVPN Client Config

Edit your `client.ovpn` file and make sure it includes these lines:

```bash
script-security 2
up /etc/openvpn/update-systemd-resolved
down /etc/openvpn/update-systemd-resolved
down-pre

# Optional: DNS search domain support
# These help with .local or internal domain lookups
dhcp-option DOMAIN-ROUTE local
```

If you're using relative `.crt`/`.key` paths, make sure they are correct or use full paths.

---

## ✅ 4. Connect Using the CLI

```bash
sudo openvpn --config /path/to/client.ovpn
```

💡 **Keep this terminal open** — it runs interactively. If successful, you should see:

```
Initialization Sequence Completed
```

---

## ✅ 5. Test DNS Resolution

Test name resolution over VPN:

```bash
resolvectl status tun0
nslookup mydevice.local
```

✅ If DNS fails but works manually like `nslookup mydevice.local 192.168.50.1`, DNS is working and the search domain needs refining.

---

## ✅ 6. Disconnect VPN

Just press `Ctrl + C` in the terminal where OpenVPN is running.

---

## ✅ 7. Optional: Make It a Background Service

If desired, create a systemd service later:

```bash
sudo cp /path/to/client.ovpn /etc/openvpn/client.conf
sudo systemctl enable --now openvpn-client@client
```

---

## ✅ 8. Logs for Troubleshooting

Use this to check logs live:

```bash
sudo journalctl -u openvpn --since "5 minutes ago" -f
```

Or when running manually:

```bash
sudo openvpn --config /path/to/client.ovpn --verb 4 --log /tmp/openvpn.log
```

---

## ✅ References

* [systemd-resolved integration](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage)
* [OpenVPN DNS fix wiki](https://wiki.archlinux.org/title/OpenVPN#DNS)

---

```
