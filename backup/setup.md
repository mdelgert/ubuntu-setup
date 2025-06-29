https://www.borgbase.com/
https://github.com/borgbase
https://restic.readthedocs.io/en/stable/040_backup.html
https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables

```bash
sudo apt-get install restic
export RESTIC_REPOSITORY=rest:https://yourkey.repo.borgbase.com
restic init
restic backup my-folder
restic snapshots
```

Or to make permenant add to .bashrc
export RESTIC_REPOSITORY=rest:https://yourkey.repo.borgbase.com
export RESTIC_PASSWORD=password

The most straightforward cloud backup solution for **Ubuntu** depends on your preference for:

* **Ease of setup**
* **Cloud provider (e.g., Google Drive, Dropbox, Azure, Backblaze, etc.)**
* **Budget (free vs. paid)**
* **Automation**

### ✅ Top Straightforward Cloud Backup Options for Ubuntu

---

### **1. Restic + Cloud Storage (Recommended for Tech-Savvy Users)**

* **Pros:** Lightweight, fast, deduplicates, encrypts by default
* **Clouds supported:** Backblaze B2, Wasabi, S3, Azure Blob, Google Cloud, etc.
* **Install:** `sudo apt install restic`
* **Example:**

  ```bash
  export RESTIC_REPOSITORY=s3:s3.amazonaws.com/your-bucket
  export RESTIC_PASSWORD=yourpassword
  restic init
  restic backup /home/yourname
  ```

✅ **Best for:** Scriptable, secure, cross-provider backups
🔧 **Needs cloud bucket + setup but rock solid**

---

### **2. Duplicati (GUI-Based)**

* **Pros:** Easy web GUI, supports encryption, scheduling
* **Clouds supported:** Google Drive, OneDrive, Dropbox, S3, B2, etc.
* **Install:**

  ```bash
  sudo apt install duplicati
  # or use .deb from https://www.duplicati.com/download
  ```

✅ **Best for:** Beginners or desktop users who prefer a UI
🌍 Web UI runs at `http://localhost:8200`

---

### **3. BorgBackup + BorgBase**

* **Pros:** Super efficient (deduplication), secure (encryption), fast
* **GUI option:** Vorta
* **BorgBase** offers a hosted solution to skip self-hosting

✅ **Best for:** Advanced users who want maximum efficiency
🧠 Requires a bit of learning but highly respected in Linux world

---

### **4. rclone (Sync-style Backup)**

* **Pros:** Syncs or mounts cloud drives like Google Drive, Dropbox
* **Install:** `sudo apt install rclone`
* **Command-line example:**

  ```bash
  rclone sync ~/Documents remote:backup
  ```

✅ **Best for:** Google Drive / Dropbox / OneDrive sync-like solutions
📝 No deduplication/encryption by default—good for personal use

---

### **5. Deja Dup (for GNOME users)**

* **Pros:** Built-in GNOME backup tool, simple GUI, supports Google Drive
* **Install:**

  ```bash
  sudo apt install deja-dup
  ```

✅ **Best for:** Desktop Ubuntu users who want a no-brainer GUI backup

---

### 🚀 Recommendation Summary

| Tool             | Best For                 | GUI | Encrypts   | Cloud Targets       |
| ---------------- | ------------------------ | --- | ---------- | ------------------- |
| **Restic**       | Power users, scriptable  | ❌   | ✅          | All major providers |
| **Duplicati**    | Easy + encrypted backups | ✅   | ✅          | Google, S3, etc.    |
| **Borg + Vorta** | Efficient & secure       | ✅   | ✅          | Self/BorgBase       |
| **rclone**       | Sync-style backups       | ❌   | ❌ (manual) | GDrive, Dropbox     |
| **Deja Dup**     | Simple desktop backups   | ✅   | ✅          | Google Drive        |
