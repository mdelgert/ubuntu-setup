
---

# 🐢 Fixing Terminal Lag in Ubuntu VM (VMware Workstation 17.x) with 3D Acceleration

## 🎯 The Issue

You're running **Ubuntu 24.04.2 LTS** as your **host**, with **VMware Workstation 17.6.3**. When you create an Ubuntu VM and enable **3D acceleration**, you notice **lag in the terminal** — keys appear slowly, commands lag, or refresh is delayed.

This issue affects both **Intel** and **AMD** systems and is confirmed by many other users across forums.

---

## 🔍 Cause

This appears to be a **long-standing VMware bug** introduced in Workstation **16.2** and persisting in 17.x:

* **3D acceleration timing issue** causes display updates to stall until another event forces a refresh.
* **Virtual keyboard (PS/2) interrupt lag** contributes to slow input.
* Observed with **GNOME, KDE, X11, Wayland**, even pure TTY — so not DE-specific.
* Not resolved by simply updating guest tools — it’s at the hypervisor graphics/input level.

---

## ✅ Solutions & Workarounds

### 1. **Disable 3D Acceleration** (Quick Fix)

* Shut down your VM.
* Go to **VM Settings > Display**.
* Uncheck **“Accelerate 3D Graphics”**.
* Start VM. Terminal lag should disappear.

🔗 [Forum report confirming fix](https://communities.vmware.com/t5/VMware-Workstation-Pro/Noticeable-typing-lag-in-Linux-VM-terminals-since-v16-2/td-p/2889254)

---

### 2. **Switch to X11 or Wayland**

If you're on **Wayland**, try X11:

* Log out > click gear icon > select **Ubuntu on Xorg** > log back in.

Or disable Wayland completely:

```bash
sudo nano /etc/gdm3/custom.conf
# Uncomment:
WaylandEnable=false
```

Reboot and verify session.

---

### 3. **Use USB Virtual Keyboard (Highly Effective)**

**Edit the VMX file** (while VM is off):

```ini
keyboard.vusb.enable = "TRUE"
keyboard.allowBothIRQs = "FALSE"
```

Alternatively, in VMware UI:

* Go to **VM Settings > Options > Advanced**.
* Set **"Optimize for games" = Always**.

✅ This **fixes the lag** while still keeping 3D acceleration enabled.

🔗 [VMware community fix](https://communities.vmware.com/t5/VMware-Workstation-Pro/Noticeable-typing-lag-in-Linux-VM-terminals-since-v16-2/td-p/2889254/page/5#comment-3682669)

---

### 4. **Update Guest Tools & Drivers**

Run this in your Ubuntu guest:

```bash
sudo apt update
sudo apt install --reinstall open-vm-tools open-vm-tools-desktop
```

Also keep **Mesa**, **kernel**, and **graphics stack** updated.

---

### 5. **Reduce Terminal App Latency**

In `~/.tmux.conf`:

```tmux
set -sg escape-time 0
```

Try lightweight terminals like:

* `xterm`
* `lxterminal`
* `kitty`

Turn off terminal effects in GNOME settings.

---

### 6. **Monitor Official Fixes**

This is a known bug that VMware has acknowledged.

🔗 [VMware community master thread](https://communities.vmware.com/t5/VMware-Workstation-Pro/Noticeable-typing-lag-in-Linux-VM-terminals-since-v16-2/td-p/2889254)

Stay up to date on new releases of VMware Workstation and **check release notes**.

---

### 7. **Extreme Measures (Not Recommended unless necessary)**

* Downgrade to **VMware Workstation 16.1.x** – no lag reported.
* Use **VirtualBox** or **KVM** instead.
* Keep `glxgears` running to force screen refresh (hacky but works):

```bash
glxgears &
```

---

## 🧠 Summary

| Setting                   | Fixes Lag | Keeps 3D |
| ------------------------- | --------- | -------- |
| Disable 3D Acceleration   | ✅         | ❌        |
| Use Virtual USB Keyboard  | ✅         | ✅        |
| Switch Wayland/X11        | Sometimes | ✅        |
| Lightweight DE / Terminal | Sometimes | ✅        |
| VMware Tools Update       | Helps     | ✅        |

---

## 🔗 References

* VMware Forum Thread: [Noticeable typing lag in Linux VM terminals since v16.2](https://communities.vmware.com/t5/VMware-Workstation-Pro/Noticeable-typing-lag-in-Linux-VM-terminals-since-v16-2/td-p/2889254)
* Reddit: [Ubuntu terminal lag fix using VMX edits](https://www.reddit.com/r/VMware/comments/xu5mbx/comment/iqyo7zm/?utm_source=share&utm_medium=web2x&context=3)
* AskUbuntu: [Terminal/tmux slow on Ubuntu 22.04 in VMware](https://askubuntu.com/questions/1412167/terminal-tmux-slow-on-ubuntu-22-04-in-vmware)
* AllThingsHow: [Fix Terminal Lag in VMware Ubuntu Guest](https://allthings.how/fix-terminal-or-tmux-slow-performance-on-ubuntu-22-04-in-vmware/)
* Ubuntu bug reference (old Mutter issue): [Launchpad bug #1953080](https://bugs.launchpad.net/ubuntu/+source/mutter/+bug/1953080)

---