https://github.com/alfredopalhares/openvpn-update-resolv-conf
https://github.com/jonathanio/update-systemd-resolved
---

### ✅ DNS is Working Internally:

* `10.6.0.1` (your ASUS router on the tunnel) **can resolve** `b1.local`.
* `nslookup b1.local` using `127.0.0.53` (which is `systemd-resolved`) **also works**.
* That means: your **WireGuard DNS setup is functionally correct**.

---

### ❗ But `ssh b1.local` Still Fails

This confirms that **glibc is still prioritizing mDNS for `.local`**, despite `systemd-resolved` resolving it successfully.

> That's the core issue — the `.local` behavior is **special-cased** in Linux and usually hijacked by `mdns`.

---

### ✅ What You Can Safely Do Next

Since your DNS is working, you don’t need to touch much — just **fix the behavior of `.local` hostnames in glibc** so apps like `ssh` use it correctly.

#### 🛠 Step 1: Disable mDNS special-case

Edit:

```bash
sudo nano /etc/systemd/resolved.conf
```

Add or modify:

```ini
[Resolve]
MulticastDNS=no
Domains=~local
```

Save and restart:

```bash
sudo systemctl restart systemd-resolved
```

#### 🛠 Step 2: Tell glibc to stop using `mdns`

Edit:

```bash
sudo nano /etc/nsswitch.conf
```

Change this line:

```diff
-hosts: files mdns4_minimal [NOTFOUND=return] dns
+hosts: files dns
```

> Or a safer fallback:

```bash
hosts: files dns mdns4
```

---

### ✅ After That

1. Disconnect and reconnect the VPN.

2. Run:

   ```bash
   ssh b1.local
   ping b1.local
   ```

3. Double-check:

   ```bash
   resolvectl query b1.local
   ```

---

### 🚀 Summary

| Action                                             | Why                                                 |
| -------------------------------------------------- | --------------------------------------------------- |
| Disable `MulticastDNS`                             | Prevent `.local` from being hijacked by mDNS        |
| Add `Domains=~local`                               | Route `.local` through VPN DNS (which works)        |
| Fix `nsswitch.conf`                                | Make `ssh` and other programs respect DNS over mDNS |
| ✅ Don't change DNS server — it's working perfectly |                                                     |

Let me know if you'd like to revert later or set this per VPN connection using a script.
