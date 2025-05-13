
---

## Default Tools for Hardening Ubuntu 24.04 LTS

Ubuntu includes several built-in tools and features that can be used to harden the system without requiring additional installations. These are available out of the box and form the foundation of a secure setup.

### 1. **UFW (Uncomplicated Firewall)**
- **Purpose**: Manages iptables to control incoming and outgoing network traffic.
- **Default Status**: Pre-installed but disabled by default.
- **Usage**:
  - Set default policies to deny incoming and allow outgoing traffic:
    ```bash
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    ```
  - Allow essential services (e.g., SSH, HTTP):
    ```bash
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    ```
  - Enable UFW:
    ```bash
    sudo ufw enable
    ```
  - Check status:
    ```bash
    sudo ufw status
    ```
- **Best Practices**:
  - Only open necessary ports.
  - Enable logging (`sudo ufw logging on`) to monitor activity.
  - Use specific rules for trusted IPs (e.g., `sudo ufw allow from 192.168.1.100 to any port 22`).

### 2. **AppArmor**
- **Purpose**: Mandatory Access Control (MAC) system that restricts programs’ capabilities via profiles.
- **Default Status**: Pre-installed and enabled, with profiles for common services (e.g., `snapd`, `cups`).
- **Usage**:
  - List active profiles:
    ```bash
    sudo apparmor_status
    ```
  - Create or modify profiles in `/etc/apparmor.d/`. For example, to enforce a profile for a custom application:
    ```bash
    sudo aa-genprof /path/to/binary
    ```
  - Reload profiles after changes:
    ```bash
    sudo systemctl reload apparmor
    ```
- **Best Practices**:
  - Ensure profiles are in `enforce` mode for critical services (not `complain` mode).
  - Audit logs in `/var/log/syslog` or `/var/log/audit/audit.log` for AppArmor denials.
  - Use `aa-complain` for testing new profiles before enforcing them.

### 3. **APT Security Features**
- **Purpose**: Secure package management with GPG signatures and repository validation.
- **Default Status**: Enabled, with Ubuntu’s official repositories using secure channels.
- **Usage**:
  - Update package lists and upgrade regularly:
    ```bash
    sudo apt update
    sudo apt upgrade -y
    ```
  - Enable automatic security updates:
    ```bash
    sudo dpkg-reconfigure -plow unattended-upgrades
    ```
    Edit `/etc/apt/apt.conf.d/50unattended-upgrades` to customize:
    ```bash
    Unattended-Upgrades::Allowed-Origins {
        "${distro_id}:${distro_codename}-security";
    };
    ```
  - Verify package signatures:
    ```bash
    sudo apt-key list
    ```
- **Best Practices**:
  - Only use trusted repositories (e.g., Ubuntu’s official or verified PPAs).
  - Enable `unattended-upgrades` for automatic security patches.
  - Remove unused packages: `sudo apt autoremove`.

### 4. **SSH (OpenSSH)**
- **Purpose**: Secure remote access to the system.
- **Default Status**: Not installed by default but commonly added via `sudo apt install openssh-server`.
- **Usage**:
  - Configure SSH securely by editing `/etc/ssh/sshd_config`:
    ```bash
    sudo nano /etc/ssh/sshd_config
    ```
    Recommended settings:
    ```bash
    Port 2222                   # Use non-standard port
    PermitRootLogin no         # Disable root login
    PasswordAuthentication no  # Require key-based authentication
    AllowUsers username        # Restrict to specific users
    ```
  - Restart SSH:
    ```bash
    sudo systemctl restart ssh
    ```
- **Best Practices**:
  - Use SSH key-based authentication instead of passwords.
  - Change the default port to reduce automated attacks.
  - Restrict access to specific users or IPs via `AllowUsers` or UFW rules.

### 5. **Systemd Security Features**
- **Purpose**: Manage services with built-in security options like sandboxing.
- **Default Status**: Enabled, as systemd is Ubuntu’s init system.
- **Usage**:
  - Harden service units by editing their configuration (e.g., `/etc/systemd/system/<service>.service`):
    ```bash
    [Service]
    ProtectSystem=strict
    ProtectHome=yes
    PrivateTmp=yes
    RestrictNamespaces=yes
    ```
  - Reload systemd and restart the service:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl restart <service>
    ```
- **Best Practices**:
  - Apply `Protect*` and `Restrict*` directives to limit service access to the filesystem, network, or kernel capabilities.
  - Disable unnecessary services: `sudo systemctl disable <service>`.

### 6. **User and Permission Management**
- **Purpose**: Control access to the system via user accounts and file permissions.
- **Default Status**: Basic user management tools (`adduser`, `passwd`, `chmod`, etc.) are included.
- **Usage**:
  - Create non-root users with limited privileges:
    ```bash
    sudo adduser username
    ```
  - Restrict sudo access by editing `/etc/sudoers.d/username`:
    ```bash
    username ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/systemctl
    ```
  - Set secure file permissions:
    ```bash
    sudo chmod 750 /home/username
    sudo chown username:username /home/username
    ```
  - Disable root account:
    ```bash
    sudo passwd -l root
    ```
- **Best Practices**:
  - Use strong passwords or key-based authentication.
  - Limit sudo privileges to specific commands.
  - Regularly audit user accounts: `cat /etc/passwd`.

---

## Recommended Best Practice Tools for Hardening

In addition to default tools, several third-party or optional tools are widely recommended for hardening Ubuntu. These enhance security by addressing specific attack vectors or providing deeper auditing capabilities.

### 1. **Fail2Ban**
- **Purpose**: Protects against brute-force attacks by banning IPs after repeated failed login attempts.
- **Installation**:
  ```bash
  sudo apt install fail2ban
  ```
- **Usage**:
  - Configure Fail2Ban to use UFW as backend (as discussed previously):
    ```bash
    sudo nano /etc/fail2ban/jail.local
    ```
    ```bash
    [DEFAULT]
    banaction = ufw
    ignoreip = 127.0.0.1/8 ::1 192.168.1.0/24
    bantime = 1h
    findtime = 10m
    maxretry = 5

    [sshd]
    enabled = true
    port = ssh
    maxretry = 3
    bantime = 3h
    ```
  - Restart Fail2Ban:
    ```bash
    sudo systemctl restart fail2ban
    ```
- **Best Practices**:
  - Enable jails for critical services (e.g., SSH, Nginx, Apache).
  - Whitelist trusted IPs to avoid accidental bans.
  - Monitor logs: `sudo tail -f /var/log/fail2ban.log`.

### 2. **Lynis**
- **Purpose**: Security auditing tool that scans for vulnerabilities and suggests hardening measures.
- **Installation**:
  ```bash
  sudo apt install lynis
  ```
- **Usage**:
  - Run a system audit:
    ```bash
    sudo lynis audit system
    ```
  - Review the report in `/var/log/lynis.log` or on-screen for suggestions.
- **Best Practices**:
  - Run Lynis regularly to identify new vulnerabilities.
  - Address high-priority warnings (e.g., outdated packages, weak permissions).
  - Use `--quick` for faster scans or `--cronjob` for automated runs.

### 3. **AIDE (Advanced Intrusion Detection Environment)**
- **Purpose**: Monitors file integrity to detect unauthorized changes.
- **Installation**:
  ```bash
  sudo apt install aide
  ```
- **Usage**:
  - Initialize the AIDE database:
    ```bash
    sudo aideinit
    sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
    ```
  - Check for changes:
    ```bash
    sudo aide --check
    ```
  - Update the database after legitimate changes:
    ```bash
    sudo aide --update
    ```
- **Best Practices**:
  - Store the AIDE database on a read-only or external medium.
  - Schedule regular checks via cron: `sudo crontab -e`.
  - Review logs for unauthorized changes.

### 4. **ClamAV**
- **Purpose**: Open-source antivirus to detect malware and viruses.
- **Installation**:
  ```bash
  sudo apt install clamav clamav-daemon
  ```
- **Usage**:
  - Update virus definitions:
    ```bash
    sudo freshclam
    ```
  - Scan the system:
    ```bash
    sudo clamscan -r / --bell -i
    ```
  - Enable real-time scanning with `clamav-daemon`:
    ```bash
    sudo systemctl enable clamav-daemon
    sudo systemctl start clamav-daemon
    ```
- **Best Practices**:
  - Schedule regular scans via cron.
  - Monitor `/var/log/clamav/clamav.log` for threats.
  - Use with caution on resource-constrained systems due to high CPU usage.

### 5. **Rkhunter (Rootkit Hunter)**
- **Purpose**: Scans for rootkits, backdoors, and other malicious software.
- **Installation**:
  ```bash
  sudo apt install rkhunter
  ```
- **Usage**:
  - Update the database:
    ```bash
    sudo rkhunter --update
    ```
  - Run a scan:
    ```bash
    sudo rkhunter --check --skip-keypress
    ```
  - Review results in `/var/log/rkhunter.log`.
- **Best Practices**:
  - Run scans after system updates or suspicious activity.
  - Configure `rkhunter` to ignore false positives in `/etc/rkhunter.conf`.
  - Automate scans via cron.

### 6. **Auditd**
- **Purpose**: Monitors system calls and logs security events for auditing.
- **Installation**:
  ```bash
  sudo apt install auditd audispd-plugins
  ```
- **Usage**:
  - Configure rules in `/etc/audit/rules.d/audit.rules`:
    ```bash
    -w /etc/passwd -p wa -k passwd_changes
    -w /etc/ssh/sshd_config -p wa -k sshd_config
    ```
  - Start the service:
    ```bash
    sudo systemctl enable auditd
    sudo systemctl start auditd
    ```
  - Search logs:
    ```bash
    sudo ausearch -k passwd_changes
    ```
- **Best Practices**:
  - Define specific audit rules for critical files and directories.
  - Regularly review logs in `/var/log/audit/audit.log`.
  - Use `aureport` for summary reports: `sudo aureport --summary`.

---

## Best Practices for Hardening Ubuntu

In addition to using the above tools, follow these best practices to ensure a robust security posture:

### 1. **Minimize Attack Surface**
- Remove unnecessary software:
  ```bash
  sudo apt purge <package>
  sudo apt autoremove
  ```
- Disable unused services:
  ```bash
  sudo systemctl disable <service>
  ```
- Avoid installing unverified PPAs or third-party software.

### 2. **Secure the Boot Process**
- Enable Secure Boot in UEFI settings to prevent unauthorized bootloaders.
- Set a GRUB password:
  ```bash
  sudo grub-mkpasswd-pbkdf2
  ```
  Edit `/etc/grub.d/40_custom` to add:
  ```bash
  set superusers="admin"
  password_pbkdf2 admin <hashed-password>
  ```
  Update GRUB:
  ```bash
  sudo update-grub
  ```

### 3. **Network Security**
- Use UFW to restrict network access.
- Enable Fail2Ban for brute-force protection.
- Disable IPv6 if not needed:
  ```bash
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  ```
  Persist in `/etc/sysctl.conf`:
  ```bash
  net.ipv6.conf.all.disable_ipv6=1
  ```

### 4. **File System Security**
- Mount partitions with secure options in `/etc/fstab`:
  ```bash
  /dev/sda1 /home ext4 defaults,nodev,nosuid 0 2
  ```
- Restrict `/tmp` with `noexec`:
  ```bash
  tmpfs /tmp tmpfs defaults,noexec,nosuid 0 0
  ```
- Use `chmod` and `chown` to secure sensitive files (e.g., `/etc/shadow`, `/etc/ssh/*`).

### 5. **User Security**
- Enforce strong password policies in `/etc/security/pwquality.conf`:
  ```bash
  minlen = 12
  dcredit = -1
  ucredit = -1
  lcredit = -1
  ocredit = -1
  ```
- Lock inactive accounts:
  ```bash
  sudo passwd -l <username>
  ```

### 6. **Regular Maintenance**
- Monitor logs with `journalctl` or specific log files (e.g., `/var/log/syslog`).
- Use Lynis and Rkhunter for periodic audits.
- Keep backups of critical configurations:
  ```bash
  sudo tar -czf /backups/etc-backup-$(date +%F).tar.gz /etc
  ```

### 7. **Docker and Container Security**
- If using Docker, configure it to respect UFW:
  Edit `/etc/docker/daemon.json`:
  ```json
  {
    "iptables": false
  }
  ```
  Restart Docker:
  ```bash
  sudo systemctl restart docker
  ```
- Use minimal container images and scan them with tools like **Trivy**:
  ```bash
  sudo apt install trivy
  trivy image <image-name>
  ```

---

## Recommended Hardening Checklist for Ubuntu 24.04 LTS

1. **Firewall**: Enable UFW with minimal open ports.
2. **Intrusion Prevention**: Install and configure Fail2Ban for SSH and other services.
3. **System Updates**: Enable `unattended-upgrades` for security patches.
4. **SSH Security**: Use key-based authentication, non-standard port, and restrict users.
5. **AppArmor**: Enforce profiles for critical services.
6. **File Integrity**: Set up AIDE to monitor changes.
7. **Auditing**: Configure `auditd` for system call monitoring.
8. **Antivirus**: Use ClamAV for malware scanning.
9. **Rootkit Detection**: Run Rkhunter periodically.
10. **System Audit**: Use Lynis for vulnerability scanning.
11. **User Management**: Disable root, limit sudo, and enforce strong passwords.
12. **Network**: Disable unused protocols (e.g., IPv6) and secure mounts.
13. **Boot Security**: Enable Secure Boot and GRUB password.
14. **Logs**: Monitor logs and enable logging for UFW, Fail2Ban, and auditd.

---

## Additional Resources

- **Ubuntu Security Guide**: [Ubuntu Server Security](https://ubuntu.com/server/docs/security-introduction)
- **CIS Ubuntu Benchmark**: [CIS Benchmarks](https://www.cisecurity.org/benchmark/ubuntu_linux)
- **DigitalOcean Hardening Guide**: [Ubuntu Server Hardening](https://www.digitalocean.com/community/tutorials/how-to-harden-your-ubuntu-18-04-server)
- **Fail2Ban Documentation**: [Fail2Ban Wiki](http://www.fail2ban.org/wiki/index.php/Main_Page)
- **Lynis Documentation**: [Lynis GitHub](https://github.com/CISOfy/lynis)

---

## Conclusion

Ubuntu 24.04 LTS provides robust default tools like **UFW**, **AppArmor**, **APT**, **OpenSSH**, and **systemd** for hardening, which can be supplemented with recommended tools like **Fail2Ban**, **Lynis**, **AIDE**, **ClamAV**, **Rkhunter**, and **Auditd**. By combining these tools with best practices—such as minimizing the attack surface, securing SSH, enabling automatic updates, and regular auditing—you can significantly enhance the security of your Ubuntu system.

For a tailored hardening plan, prioritize tools based on your use case (e.g., server vs. desktop, web hosting vs. personal use). Regularly audit with Lynis and monitor logs to stay ahead of potential threats. If you need specific configurations or have questions about a particular tool, let me know!