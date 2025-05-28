# UbuntuSetup

This repository contains scripts and documentation to efficiently set up and configure an Ubuntu system.

## Top-Level Scripts

- **apt.sh**: Automates installation of essential packages using `apt`.
- **chmod.sh**: Adjusts file permissions.
- **docker.sh**: Installs and configures Docker.
- **firmware.sh**: Firmware-related setup.
- **git.sh**: Sets up Git and related configurations.
- **keys.sh**: Manages SSH keys.
- **kvm.sh**: Configures KVM for virtualization.
- **lid.sh**: Lid (laptop) configuration.
- **logs.sh**: Log management utilities.
- **mok-reset.sh**: Resets Machine Owner Key (MOK).
- **passwordless.sh**: Enables passwordless sudo for specified users.
- **repos.sh**: Adds and manages software repositories.
- **screenprint.md**: Screen printing instructions.
- **setup.sh**: Main setup script to orchestrate the configuration process.
- **snap.sh**: Installs and manages Snap packages.
- **speedtest.md**: Speedtest instructions.
- **swap.sh**: Configures swap settings.
- **ventoy.sh**: Sets up Ventoy for bootable USB drives.

## Documentation

- **backupdisk.md**: Guide for setting up disk backups.
- **fail2ban.md**: Fail2ban setup guide.
- **hardening.md**: System hardening tips.
- **livepatch.md**: Instructions for enabling Ubuntu Livepatch.
- **Plugins.md**: Information about useful plugins.
- **screenprint.md**: Screen printing instructions.
- **speedtest.md**: Speedtest instructions.
- **virtualbox.md**: VirtualBox setup guide.

## Directories & Their Contents

### email/
- **email.md**: Email setup documentation.
- **email.sh**: Email setup script.

### firewall/
- **gufw-install.sh** / **gufw-uninstall.sh**: Install/uninstall GUFW firewall.
- **gufw.md**: GUFW documentation.
- **ufw-install.sh** / **ufw-uninstall.sh** / **ufw-disabled.sh**: UFW firewall scripts.
- **ufw.md**: UFW documentation.
- **applications.d/**: Contains firewall application rules (e.g., rdp, samba, rules.sh).

### samba/
- **samba-install.sh** / **samba-uninstall.sh** / **samba-update.sh**: Samba management scripts.
- **samba.md**: Samba documentation.
- **smb.conf.original/shared/simple**: Example Samba configuration files.

### scripts/
- **backup.sh**: Backup script.

### veeam/
- **veeam.sh**: Installs and configures Veeam Backup.
- **delete.md**: Instructions for removing Veeam.
- **veeam-release-deb_1.0.9_amd64.deb**: Veeam installation package.

### vmware/
- **TerminalLag.md**: Terminal lag troubleshooting.
- **VmTools.md**: VMware Tools documentation.
- **vmware-install.sh**: Installs VMware Workstation.
- **vmware-modules-sign.sh**: Signs VMware kernel modules.
- **vmware-mok-enroll.sh**: Enrolls MOK for VMware modules.
- **vmware-tools.sh**: Installs VMware Tools.
- **Wslconfig.md**: WSL configuration notes.

### vpn/
- **vpn-nsswitch-install.sh** / **vpn-nsswitch-uninstall.sh**: VPN NSSwitch install/uninstall scripts.
- **ovpn/**: OpenVPN scripts and documentation (openvpn.md, ovpn.sh, ovpnclient.md).
- **wireguard/**: WireGuard scripts, configs, and docs (setup.sh, wg0.conf, docs/ with dns.md, info.md, nsswitch.md, port.md, setup.md, etc.).

## Additional Resources

- [Ubuntu Old Releases](https://old-releases.ubuntu.com/releases/): Access older Ubuntu releases.

## License

This project is licensed under the terms of the LICENSE file included in this repository.