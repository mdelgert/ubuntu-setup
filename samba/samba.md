
---

# 📁 Simple Samba Share Setup – Ubuntu 24.04.2

This guide sets up a minimal Samba share with a single folder and no default shares or extra configuration.

---

## 🧰 Prerequisites

* Ubuntu 24.04.2 LTS
* Root or sudo privileges

---

## 🔧 Step 1: Install Samba

```bash
sudo apt update
sudo apt install samba -y
```

---

## 📁 Step 2: Create Shared Folder

```bash
mkdir /mnt/d1/shared
```

> This folder will be readable/writable by all authenticated users.

---

## 👤 Step 3: Create Samba User

Create a Linux user (if not already exists):

```bash
sudo useradd sambauser
```

Set a Samba password:

```bash
sudo smbpasswd -a sambauser
```

---

## ⚙️ Step 4: Configure Samba

Edit the config file:

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.bk
sudo truncate -s 0 /etc/samba/smb.conf
sudo nano /etc/samba/smb.conf
```

Wipe the file and use this **minimal config**:

```ini
[global]
   workgroup = WORKGROUP
   server string = Simple Samba Server
   map to guest = Bad User
   log file = /var/log/samba/log.%m
   max log size = 1000

[Shared]
   path = /srv/samba/shared
   browsable = yes
   writable = yes
   guest ok = no
   valid users = sambauser
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

## 🔁 Step 5: Restart Samba

```bash
sudo systemctl restart smbd
sudo systemctl enable smbd
```

---

## 🔓 Step 6: Allow Samba Through UFW (if enabled)

```bash
sudo ufw allow 'Samba'
```

---

## 🧪 Step 7: Test the Share

From another machine:

* **Linux**:

  ```bash
  smbclient //ubuntu-hostname/Shared -U sambauser
  ```
* **Windows**:

  * Open File Explorer
  * Enter `\\<ubuntu-ip>\Shared` in the address bar
  * Authenticate with `sambauser` and the password

---

## ✅ Troubleshooting

* Check Samba status:

  ```bash
  sudo systemctl status smbd
  ```
* Check logs:

  ```bash
  sudo journalctl -u smbd
  ```

---

## 🔁 Useful Commands

* List shares:

  ```bash
  smbclient -L localhost -U sambauser
  ```

* List connected users:

  ```bash
  sudo smbstatus
  ```

---

## 🧼 Cleanup

To remove Samba:

```bash
sudo apt purge samba samba-common -y
```

---

## 📎 References

* [Samba Documentation](https://www.samba.org/samba/docs/)
* [Ubuntu UFW Guide](https://help.ubuntu.com/community/UFW)

---
