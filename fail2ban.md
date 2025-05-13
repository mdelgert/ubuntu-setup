
---

# 🛡️ Fail2Ban Setup Tutorial for Ubuntu (Latest Version)

**Fail2Ban** helps secure your Ubuntu server by scanning log files and banning IPs that show signs of malicious activity, such as brute-force attacks.

---

## 📦 Step 1: Install Fail2Ban

Open a terminal and run:

```bash
sudo apt update
sudo apt install fail2ban
```

---

## 🧪 Step 2: Check Fail2Ban Status

After installation, check if the service is running:

```bash
sudo systemctl status fail2ban
```

To start and enable it at boot:

```bash
sudo systemctl enable --now fail2ban
```

---

## ⚙️ Step 3: Configure Fail2Ban (Best Practice)

### 🔒 Don’t edit the main config (`/etc/fail2ban/jail.conf`) directly.

Instead, create or edit a local override file:

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

Or start a clean version:

```bash
sudo nano /etc/fail2ban/jail.local
```

### ✍️ Basic recommended config:

```ini
[DEFAULT]
bantime = 10m
findtime = 10m
maxretry = 5
backend = systemd
destemail = your@email.com
sender = fail2ban@yourdomain.com
mta = sendmail
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = systemd
```

---

## 🔧 Step 4: Review and Enable Jails

Fail2Ban uses "jails" for each service it protects.

Run this to check current jails:

```bash
sudo fail2ban-client status
```

To check SSH jail status:

```bash
sudo fail2ban-client status sshd
```

---

## 📜 Step 5: Test Fail2Ban

### 💣 Simulate a failed SSH login

From another machine or locally:

```bash
ssh invaliduser@your-server-ip
```

Repeat `maxretry` times (default: 5). Then check:

```bash
sudo fail2ban-client status sshd
```

You should see a banned IP address.

---

## 🔁 Step 6: Restart Fail2Ban After Changes

Whenever you edit config files:

```bash
sudo systemctl restart fail2ban
```

Or reload config:

```bash
sudo fail2ban-client reload
```

---

## 🔍 Step 7: View Logs

* Fail2Ban log:

  ```bash
  sudo tail -f /var/log/fail2ban.log
  ```

* Check ban info:

  ```bash
  sudo fail2ban-client status
  sudo fail2ban-client status sshd
  ```

---

## 🧼 Step 8: Unban an IP

If needed:

```bash
sudo fail2ban-client set sshd unbanip 192.168.1.100
```

---

## 🔐 Optional: Protect Other Services

Fail2Ban supports many services, such as:

* NGINX / Apache (`/etc/fail2ban/filter.d/nginx-http-auth.conf`)
* Web applications (like WordPress, Nextcloud)
* Mail servers
* Custom filters (you can write your own regex)

To enable a new jail, add it to `jail.local`:

```ini
[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log
```

---

## ✅ Summary

| Action           | Command / File                               |
| ---------------- | -------------------------------------------- |
| Install Fail2Ban | `sudo apt install fail2ban`                  |
| Config file      | `/etc/fail2ban/jail.local`                   |
| Restart service  | `sudo systemctl restart fail2ban`            |
| View bans        | `sudo fail2ban-client status sshd`           |
| View logs        | `sudo tail -f /var/log/fail2ban.log`         |
| Unban IP         | `sudo fail2ban-client set sshd unbanip <IP>` |

---
