
---

# 🔒 Ubuntu UFW Firewall Setup Guide (Latest Ubuntu)

## ✅ What is UFW?

**UFW (Uncomplicated Firewall)** is a user-friendly command-line interface for managing **iptables** firewall rules on Ubuntu. It helps secure your server by allowing only specific inbound/outbound traffic.

---

## 📦 Step 1: Install UFW (if not already installed)

UFW usually comes pre-installed, but verify with:

```bash
sudo apt update
sudo apt install ufw
```

---

## 🚦 Step 2: Check UFW Status

```bash
sudo ufw status verbose
```

If it says `inactive`, then it hasn't been enabled yet.

---

## 🔐 Step 3: Default Rules (Highly Recommended)

Deny all incoming by default, allow all outgoing:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

---

## 🌐 Step 4: Allow Essential Services

Here are some common rules you might add:

```bash
# Allow SSH (port 22)
sudo ufw allow ssh
# OR explicitly
sudo ufw allow 22/tcp

# Allow HTTP (port 80)
sudo ufw allow http
# OR
sudo ufw allow 80/tcp

# Allow HTTPS (port 443)
sudo ufw allow https
# OR
sudo ufw allow 443/tcp
```

---

## 👷‍♂️ Step 5: Enable UFW

Once rules are configured, enable the firewall:

```bash
sudo ufw enable
```

**⚠️ WARNING:** Enabling UFW without allowing SSH will lock you out of a remote server.

---

## 🔍 Step 6: View and Manage Rules

* Show rules:

  ```bash
  sudo ufw status numbered
  ```

* Delete rule by number:

  ```bash
  sudo ufw delete [number]
  ```

* Reset all rules:

  ```bash
  sudo ufw reset
  ```

---

## 🔧 Step 7: Advanced Rules (Optional)

### Allow a specific IP

```bash
sudo ufw allow from 192.168.1.100
```

### Allow IP to a specific port

```bash
sudo ufw allow from 192.168.1.100 to any port 22 proto tcp
```

### Deny IP

```bash
sudo ufw deny from 203.0.113.1
```

---

## 🔁 Step 8: Disable or Reload UFW

* Disable firewall:

  ```bash
  sudo ufw disable
  ```

* Reload rules:

  ```bash
  sudo ufw reload
  ```

---

## 🧪 Step 9: Test Configuration

Use `nmap` or similar tools from another machine:

```bash
nmap -p 22,80,443 your.server.ip
```

---

## 📌 Notes

* UFW does **not persist** after `ufw reset`, so re-add any needed rules.
* UFW works on both IPv4 and IPv6 by default.
* You can edit `/etc/ufw/ufw.conf` to make UFW start at boot (`ENABLED=yes`).

---

## ✅ Example Setup Summary

```bash
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 80,443/tcp
sudo ufw enable
```

---
