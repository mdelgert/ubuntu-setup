## VMware Swap Space Configuration

VMware Workstation recommends 8 GB of system swap space for optimal performance. If you encounter performance issues, follow these steps to increase your system swap space on Ubuntu:

1. **Check Current Swap Space**
   ```bash
   sudo swapon --show
   ```

2. **Turn Off Swap Temporarily (Optional)**
   ```bash
   sudo swapoff -a
   ```

3. **Increase Swap Space Using a Swap File**
   - Create a new swap file:
     ```bash
     sudo fallocate -l 16G /swap.img
     ```
   - Set correct permissions:
     ```bash
     sudo chmod 600 /swap.img
     ```
   - Format the file as swap:
     ```bash
     sudo mkswap /swap.img
     ```
   - Enable the swap file:
     ```bash
     sudo swapon /swap.img
     ```
   - Make it permanent by adding the following line to `/etc/fstab`:
     ```
     /swap.img none swap sw 0 0
     ```

4. **Verify the Swap Space**
   ```bash
   sudo swapon --show
   ```

5. **Configure VMware to Use Reserved Host RAM (Optional)**
   In VMware Workstation, go to **Edit > Preferences > Memory** and configure virtual machines to use reserved host RAM instead of relying on swap.

For more details, refer to the [swap.md](vmware/swap.md) file.