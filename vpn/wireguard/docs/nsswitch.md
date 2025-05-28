#### Steps to Automate Scripts with NetworkManager

1. **Verify VPN Connection Name**  
   Confirm the VPN connection is named "WireGuard" in NetworkManager.
   - **Command**:
     ```bash
     nmcli connection show
     ```
     Look for a connection named "WireGuard" (case-sensitive). Note the exact name (e.g., `WireGuard`) and type (e.g., `vpn` with `vpn.service: openvpn`).
     Example output:
     ```
     NAME       UUID                                  TYPE  DEVICE
     WireGuard  12345678-1234-1234-1234-1234567890ab  vpn   --
     ```
   - If it’s not listed or is a WireGuard connection (`type: wireguard`), clarify, as the setup differs slightly.

2. **Ensure Scripts Are in Place**  
   Verify that `nsswitch_up.sh` and `nsswitch_down.sh` are executable and correctly configured (from previous artifacts).
   - **Check Scripts**:
     ```bash
     ls -l /path/to/nsswitch_up.sh /path/to/nsswitch_down.sh
     ```
     Ensure they’re executable (`chmod +x`):
     ```bash
     sudo chmod +x /path/to/nsswitch_up.sh /path/to/nsswitch_down.sh
     ```
     Move to a system directory for reliability:
     ```bash
     sudo mv /path/to/nsswitch_up.sh /etc/nsswitch.d/nsswitch_up.sh
     sudo mv /path/to/nsswitch_down.sh /etc/nsswitch.d/nsswitch_down.sh
     ```
   - **Verify Configuration Files**:
     Ensure `/etc/nsswitch.d/nsswitch_up.conf` and `/etc/nsswitch.d/nsswitch_down.conf` exist:
     ```bash
     cat /etc/nsswitch.d/nsswitch_up.conf
     cat /etc/nsswitch.d/nsswitch_down.conf
     ```
     Expected:
     ```
     hosts: files dns mdns4
     ```
     and
     ```
     hosts: files mdns4_minimal [NOTFOUND=return] dns
     ```

3. **Create a NetworkManager Dispatcher Script**  
   Create a dispatcher script to run `nsswitch_up.sh` when the VPN activates and `nsswitch_down.sh` when it deactivates, specifically for the "WireGuard" connection.
   - **Command**:
     ```bash
     sudo nano /etc/NetworkManager/dispatcher.d/99-vpn-nsswitch.sh
     ```
     See example 99-vpn-nsswitch.sh
     Save and exit.
   - **Set Permissions**:
     ```bash
     sudo chmod +x /etc/NetworkManager/dispatcher.d/99-vpn-nsswitch.sh
     ```
   - **Explanation**:
     - The script checks the interface (`$1`) and action (`$2`) passed by NetworkManager.
     - It verifies the connection name matches "WireGuard" using `nmcli`.
     - For `vpn-up`, it runs `nsswitch_up.sh`; for `vpn-down`, it runs `nsswitch_down.sh`.
     - Logs actions to `/var/log/nsswitch_script.log`, matching the scripts’ logging.
     - Ensures scripts are executable and handles errors.

4. **Test the Dispatcher Script**  
   Activate and deactivate the VPN to verify the scripts run automatically.
   - **Activate VPN**:
     ```bash
     nmcli connection up WireGuard
     ```
     Or use the Network Settings GUI to enable the "WireGuard" VPN.
   - **Check nsswitch.conf**:
     ```bash
     cat /etc/nsswitch.conf
     ```
     Expect:
     ```
     hosts: files dns mdns4
     ```
   - **Check Logs**:
     ```bash
     cat /var/log/nsswitch_script.log
     ```
     Look for:
     ```
     [2025-05-23 22:46:05] [INFO] Running /etc/nsswitch.d/nsswitch_up.sh for WireGuard VPN up on tun0
     [2025-05-23 22:46:05] [INFO] Successfully updated /etc/nsswitch.conf with 'hosts: files dns mdns4'
     ```
   - **Test SSH**:
     ```bash
     ssh b1.local
     ```
   - **Deactivate VPN**:
     ```bash
     nmcli connection down WireGuard
     ```
     Or disable via GUI.
   - **Check nsswitch.conf**:
     ```bash
     cat /etc/nsswitch.conf
     ```
     Expect:
     ```
     hosts: files mdns4_minimal [NOTFOUND=return] dns
     ```
   - **Check Logs**:
     Look for:
     ```
     [2025-05-23 22:47:05] [INFO] Running /etc/nsswitch.d/nsswitch_down.sh for WireGuard VPN down on tun0
     [2025-05-23 22:47:05] [INFO] Successfully reverted /etc/nsswitch.conf to 'hosts: files mdns4_minimal [NOTFOUND=return] dns'
     ```

5. **Handle Full nsswitch.conf Content (Optional)**  
   If `nsswitch_up.conf` and `nsswitch_down.conf` contain only the `hosts` line, the scripts overwrite `/etc/nsswitch.conf` with just that line, breaking other NSS settings (e.g., `passwd`, `group`). To include the full `nsswitch.conf`:
   - **Create Full Config Files**:
     ```bash
     sudo cp /etc/nsswitch.conf /etc/nsswitch.d/nsswitch_up.conf
     sudo cp /etc/nsswitch.conf /etc/nsswitch.d/nsswitch_down.conf
     ```
     Edit `nsswitch_up.conf`:
     ```bash
     sudo nano /etc/nsswitch.d/nsswitch_up.conf
     ```
     Set:
     ```
     hosts: files dns mdns4
     ```
     Edit `nsswitch_down.conf` to keep:
     ```
     hosts: files mdns4_minimal [NOTFOUND=return] dns
     ```
   - **Update Scripts**:
     Ensure `nsswitch_up.sh` and `nsswitch_down.sh` copy these full files (already configured to do so).
   - **Test**:
     Re-run steps 4 to confirm all NSS settings are preserved.

**Potential Issues and Mitigations**  
- **Incorrect Connection Name**: If "WireGuard" isn’t the exact name, the dispatcher won’t trigger. Verify with `nmcli connection show` and update `CONNECTION_NAME` in the script.
- **Script Permissions**: Ensure `nsswitch_up.sh` and `nsswitch_down.sh` are executable and in `/etc/nsswitch.d/`.
- **NetworkManager Integration**: If NetworkManager doesn’t trigger the dispatcher, check:
  ```bash
  systemctl status NetworkManager-dispatcher.service
  ```
  Restart:
  ```bash
  sudo systemctl restart NetworkManager-dispatcher.service
  ```
- **mDNS Impact**: As noted, `hosts: files dns mdns4` may delay mDNS resolution (e.g., `printer.local`). Test:
  ```bash
  ping printer.local
  avahi-browse -a
  ```
  If issues arise, edit `nsswitch_up.conf` to use:
  ```
  hosts: files mdns4_minimal dns
  ```
- **Log File Access**: Ensure `/var/log/nsswitch_script.log` is writable:
  ```bash
  sudo touch /var/log/nsswitch_script.log
  sudo chmod 644 /var/log/nsswitch_script.log
  ```

**Reverting the Setup**  
To disable the automation:
- **Remove Dispatcher Script**:
  ```bash
  sudo rm /etc/NetworkManager/dispatcher.d/99-vpn-nsswitch.sh
  ```
- **Run nsswitch_down.sh**:
  ```bash
  sudo /etc/nsswitch.d/nsswitch_down.sh
  ```
- **Verify**:
  ```bash
  cat /etc/nsswitch.conf
  ```
  Expect:
  ```
  hosts: files mdns4_minimal [NOTFOUND=return] dns
  ```
- **Clean Up**:
  Remove scripts and configs if no longer needed:
  ```bash
  sudo rm /etc/nsswitch.d/nsswitch_up.sh /etc/nsswitch.d/nsswitch_down.sh
  sudo rm /etc/nsswitch.d/nsswitch_up.conf /etc/nsswitch.d/nsswitch_down.conf
  ```

**Clarification on VPN Type**  
Your query mentions a "WireGuard" VPN, but the context suggests OpenVPN (due to `.ovpn` files and router setup). If "WireGuard" is a WireGuard connection (`type: wireguard` in `nmcli`), the dispatcher script still works, as NetworkManager uses `vpn-up` and `vpn-down` events for both OpenVPN and WireGuard. However, confirm the type:
```bash
nmcli connection show WireGuard
```
If it’s WireGuard, ensure `nmcli connection show WireGuard` includes `ipv4.dns: 192.168.50.1` and `ipv4.dns-search: local`. If it’s OpenVPN, the setup above is correct.

**Next Steps If Issues Persist**  
If the scripts don’t run or SSH fails:
- Check dispatcher logs:
  ```bash
  cat /var/log/nsswitch_script.log
  journalctl -u NetworkManager-dispatcher.service
  ```
- Verify VPN connection name and type:
  ```bash
  nmcli connection show
  ```
- Test scripts manually:
  ```bash
  sudo /etc/nsswitch.d/nsswitch_up.sh
  ssh b1.local
  sudo /etc/nsswitch.d/nsswitch_down.sh
  ```
- Provide:
  - Output of `nmcli connection show WireGuard`.
  - Output of `cat /var/log/nsswitch_script.log`.
  - Output of `getent hosts b1.local` after VPN activation.
  - Full `~/.ssh/config` content.
  - Router model and firmware version.

**Conclusion**  
The NetworkManager dispatcher script `99-vpn-nsswitch.sh` automates running `nsswitch_up.sh` when the "WireGuard" VPN is enabled and `nsswitch_down.sh` when disabled, copying `nsswitch_up.conf` and `nsswitch_down.conf` to `/etc/nsswitch.conf`. It handles OpenVPN (or WireGuard) events, logs actions, and ensures reliability. Test mDNS devices post-change, and use logs to troubleshoot. The setup is reversible, and clarification on the VPN type (OpenVPN vs. WireGuard) will refine the solution if needed.

### Key Citations
- [NetworkManager Dispatcher Documentation](https://networkmanager.dev/docs/api/latest/dispatcher.html)
- [Ubuntu Manpage: nsswitch.conf](https://manpages.ubuntu.com/manpages/jammy/man5/nsswitch.conf.5.html)
- [systemd-resolved Documentation](https://www.freedesktop.org/software/systemd/man/resolved.conf.html)