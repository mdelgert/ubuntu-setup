### ✅ WireGuard Port Details

* **Default Port**: `51820`
* **Protocol**: **UDP only**
* **TCP is not supported** by WireGuard.

---

### 🔧 Should You Change the Port?

**Usually no**, unless:

* Your ISP or mobile network blocks uncommon ports like 51820.
* You want to obscure the VPN by running on a common port like 443 or 53 (obfuscation, not security).
* You're already using 51820 on another server.

If you have no specific reason, it's best to **leave it as `51820/udp`**.

---

### 🌐 Do You Need to Open Ports with Your ISP?

* **If your ASUS GT-AX11000 Pro has a public IP on the WAN interface**:
  ✅ You only need to allow/forward **UDP 51820** on your **router**.

* **If you're behind CG-NAT or double NAT (common with 5G/home ISP routers)**:
  ❌ You **can't port forward** from your ASUS router unless the upstream modem/router is also configured to forward UDP 51820 to your ASUS WAN IP.

To check your public IP:

```bash
curl ifconfig.me
```

Then log in to your ASUS router and look at the WAN IP in the web GUI.

* If it **matches**: ✅ you have a public IP.
* If it’s something like `100.x.x.x` or `192.168.x.x`: ❌ you're behind CG-NAT or double NAT.

---

### 🧱 Firewall/Port Forwarding Summary

| Where                              | Rule                                                                                          |
| ---------------------------------- | --------------------------------------------------------------------------------------------- |
| **Router Firewall**                | Allow **UDP 51820**                                                                           |
| **Router Port Forwarding**         | Forward **UDP 51820 → 192.168.50.1** (if using a DMZ host or port forwards behind double NAT) |
| **ISP/Modem (if upstream exists)** | Also forward **UDP 51820** if possible                                                        |
| **Ubuntu Client**                  | No ports need to be opened — it's a VPN client                                                |

---