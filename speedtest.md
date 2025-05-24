
---

### **1. `speedtest-cli` (based on Speedtest.net)**

**Install:**

```bash
sudo apt update
sudo apt install speedtest-cli
```

**Usage:**

```bash
speedtest
```

You can also use:

```bash
speedtest --simple
```

to get a shorter output (ping, download, upload).

---

### **2. `fast` (by Netflix)**

**Install:**

```bash
sudo snap install fast
```

**Usage:**

```bash
fast
```

This gives a quick download speed result (no upload or ping).

---

### **3. `iperf3` (for testing between two devices)**

Best used to test Wi-Fi speed **within your network** (e.g., between your PC and your router or another local server).

**Install:**

```bash
sudo apt install iperf3
```

**Usage:**

* On server (e.g., your router if it supports it):

```bash
iperf3 -s
```

* On client:

```bash
iperf3 -c <server_ip>
```

---

### **4. `nload` or `bmon` (for real-time bandwidth monitoring)**

Useful for seeing live data usage, not synthetic speed tests.

**Install:**

```bash
sudo apt install nload bmon
```

**Usage:**

```bash
nload
# or
bmon
```

---

### **Summary Table**

| Tool          | Purpose                   | Test Type     | Install via |
| ------------- | ------------------------- | ------------- | ----------- |
| speedtest-cli | Speedtest.net style test  | Internet      | `apt`       |
| fast          | Netflix speed test        | Internet (DL) | `snap`      |
| iperf3        | Network performance test  | LAN           | `apt`       |
| nload/bmon    | Live bandwidth monitoring | Ongoing usage | `apt`       |
