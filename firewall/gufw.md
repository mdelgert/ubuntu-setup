
---

# 🖥️ GUFW Firewall Setup on Ubuntu (Latest Version)

> A beginner-friendly graphical interface for managing UFW (Uncomplicated Firewall)

---

## 📦 Step 1: Install GUFW

Open a terminal and run:

```bash
sudo apt update
sudo apt install gufw
```

Or install via **Ubuntu Software Center**:

* Search for **“Firewall Configuration”**
* Click **Install**

---

## 🔓 Step 2: Launch GUFW

You can launch GUFW via:

* **Application Menu → Firewall Configuration**
* Or from terminal:

```bash
gufw
```

> You’ll be prompted for your **sudo** password.

---

## ✅ Step 3: Enable the Firewall

Once GUFW is open:

1. Toggle the **Status** switch to **ON**
2. Default rules:

   * **Incoming**: Deny
   * **Outgoing**: Allow

---

## 🌐 Step 4: Allow or Deny Common Applications

Go to the **Rules** tab → Click **+** (Add Rule):

1. **Preconfigured Tab**:

   * Choose **Category** (e.g., Internet)
   * Select an app like `SSH`, `HTTP`, `HTTPS`, etc.
   * Click **Add**

2. **Simple Tab** (Custom Ports):

   * **Policy**: Allow or Deny
   * **Direction**: In or Out
   * **Port**: e.g., `22` for SSH
   * **Protocol**: TCP or UDP

3. **Advanced Tab**:

   * Specify **IP address**, **range**, or **subnet**.
   * Add port and protocol filters for fine-tuned access.

---

## 🔧 Step 5: Manage Rules

From the main window:

* Rules are shown in a list
* You can **disable**, **edit**, or **remove** individual rules
* Use filters for **Incoming** and **Outgoing**

---

## 🔐 Step 6: Use Profiles (Optional)

Click the **Profile** dropdown:

* Use separate rule sets for **Home**, **Public**, or **Office**
* Customize each profile with its own rules

---

## 🧪 Step 7: Test Firewall Behavior

Try accessing your machine from another device:

* Test **SSH**, **HTTP**, etc.
* Confirm that **blocked ports** are not reachable

You can also run `nmap` from another system:

```bash
nmap your.ip.address
```

---

## 🚫 Step 8: Disable GUFW (Optional)

To turn the firewall off:

* Toggle **Status** to **OFF** in the GUI
* Or run from terminal:

```bash
sudo ufw disable
```

---

## 📝 Summary

| Action          | Description                     |
| --------------- | ------------------------------- |
| Install         | `sudo apt install gufw`         |
| Launch          | `gufw` or via Applications      |
| Enable Firewall | Toggle ON                       |
| Add Rule        | Use "+" button                  |
| Profiles        | Switch between Home/Public/etc. |
| Test Ports      | Use `nmap` or external device   |

---

## 📸 Bonus: Screenshot Hints

* ✅ GUFW ON status: Green toggle
* 🔒 SSH rule added: Shows port 22 allowed
* 🛠️ Advanced rule: Specific IP + port combo

---
