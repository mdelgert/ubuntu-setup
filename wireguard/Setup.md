
---

# 📘 WireGuard VPN Setup on ASUS GT-AX11000 Pro

## 🛠️ Prerequisites

* **Firmware Version**: Ensure your router is running firmware version **3.0.0.4.388.23000** or later, as WireGuard support was introduced in these versions. You can check and update your firmware via the router's web interface.

* **Public IP Address**: Your router must have a public WAN IP address to allow external connections. If you're behind a CGNAT or double NAT, consult your ISP or consider setting up port forwarding accordingly.

---

## 🔧 Step 1: Enable WireGuard VPN Server on the Router

1. **Access Router Interface**:

   * Connect to your router via Wi-Fi or Ethernet.
   * Open a web browser and navigate to `http://router.asus.com` or `http://192.168.50.1`.

2. **Log In**:

   * Enter your router's admin username and password.

3. **Navigate to VPN Settings**:

   * Go to **Advanced Settings** > **VPN**.

4. **Enable WireGuard Server**:

   * Under the **VPN Server** tab, select **WireGuard**.
   * Click **Enable WireGuard VPN Server**.

5. **Configure Server Settings**:

   * **Server Port**: Use the default or specify a custom port.
   * **Tunnel IP**: Set to a private IP range, e.g., `10.6.0.1/24`.
   * **Peer IP**: Assign an IP for the client, e.g., `10.6.0.2/32`.
   * **Allowed IPs**: Specify the client's allowed IPs, e.g., `0.0.0.0/0` for full tunnel or `10.6.0.2/32` for split tunnel.
   * **Pre-shared Key**: Optionally add for enhanced security.

6. **Save Configuration**:

   * Click **Apply** to save the settings.

7. **Export Configuration**:

   * Download the generated `.conf` file for the client setup.

---

## 💻 Step 2: Set Up WireGuard Client on Ubuntu

1. **Install WireGuard**:

   ```bash
   sudo apt update
   sudo apt install wireguard
   ```

2. **Place Configuration File**:

   * Save the downloaded `.conf` file to `/etc/wireguard/`:

     ```bash
     sudo mv ~/Downloads/client.conf /etc/wireguard/wg0.conf
     ```

3. **Set Permissions**:

   ```bash
   sudo chmod 600 /etc/wireguard/wg0.conf
   ```

4. **Start WireGuard Interface**:

   ```bash
   sudo wg-quick up wg0
   ```

5. **Verify Connection**:

   ```bash
   sudo wg
   ```

6. **Enable at Boot (Optional)**:

   ```bash
   sudo systemctl enable wg-quick@wg0
   ```

---

## 🌐 Step 3: Test the VPN Connection

* **Ping Internal Devices**:

  ```bash
  ping 192.168.50.1
  ```

* **Access Services**:

  * Try accessing your home services (e.g., SSH, web interfaces) using their internal IPs.

* **Check IP Address**:

  ```bash
  curl ifconfig.me
  ```

  * This should return your home network's public IP if using a full tunnel.

---

## 🧩 Troubleshooting Tips

* **DNS Resolution Issues**:

  * If you encounter DNS issues, consider specifying DNS servers in your WireGuard configuration:

    ```ini
    DNS = 192.168.50.1
    ```

* **Firewall Settings**:

  * Ensure that your router's firewall allows WireGuard traffic on the specified port.

* **Multiple Clients**:

  * For additional clients, repeat the server configuration steps, assigning unique IPs for each.

---

## 📄 References

* ASUS Official Guide: [How to set up WireGuard® VPN server](https://www.asus.com/support/faq/1048280/)
* ASUS Support Page: [ROG Rapture GT-AX11000 Pro Support](https://www.asus.com/supportonly/gt-ax11000%20pro/helpdesk/)

---

By following this guide, you should have a secure and efficient WireGuard VPN setup on your ASUS GT-AX11000 Pro router, providing seamless remote access to your home network from your Ubuntu desktop.
