# Adding a Secondary Disk to Ubuntu

This guide explains how to add a secondary disk to your Ubuntu system, including partitioning, formatting, and mounting the disk.

## Steps to Add a Secondary Disk

### 1. Identify the Disk
1. Open a terminal and run the following command to list all disks:
   ```bash
   sudo fdisk -l
   ```
   
2. Identify the new disk (e.g., `/dev/nvme0n1`).

### 2. Partition the Disk
1. Use the `fdisk` utility to create a new partition:
   ```bash
   sudo fdisk /dev/nvme0n1
   ```
2. Follow the prompts to:
   - Create a new partition (`n` command).
   - Write changes (`w` command).

### 3. Format the Partition
1. Format the new partition with a filesystem (e.g., ext4):
   ```bash
   sudo mkfs.ext4 /dev/nvme0n1
   ```

### 4. Create a Mount Point
1. Create a directory to mount the disk:
   ```bash
   sudo mkdir /mnt/d1
   ```

### 5. Mount the Disk
1. Mount the disk to the created directory:
   ```bash
   sudo mount /dev/nvme0n1 /mnt/d1
   ```
2. Verify the disk is mounted:
   ```bash
   df -h
   ```

### 6. Make the Mount Permanent
1. Find the UUID of the partition:
   ```bash
   sudo blkid
   ```
   Note the `UUID` of the partition (e.g., `/dev/sdb1`).

2. Edit the `/etc/fstab` file to ensure the disk mounts automatically on boot:
   ```bash
   sudo nano /etc/fstab
   ```
3. Add the following line to the file:
   ```
   UUID=<your-partition-uuid>  /mnt/backupdisk  ext4  defaults  0  2
   ```
   Replace `<your-partition-uuid>` with the actual UUID from the `blkid` command.

4. Save and exit the editor.

5. Test the configuration:
   ```bash
   sudo mount -a
   ```

### 7. Set Permissions (Optional)
1. Adjust permissions for the mount point as needed:
   ```bash
   sudo chown -R $USER:$USER /mnt/d1
   ```

Your secondary disk is now ready to use.