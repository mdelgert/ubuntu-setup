When you enable **Secure Boot**, Ubuntu enforces **Kernel Module Signature Verification**, which prevents unsigned modules like `vmmon` (VMware Workstation’s kernel module) from loading. Here’s how to resolve it:

### **Solution: Sign VMware Modules for Secure Boot**

#### **Step 1: Check the Secure Boot Status**
Run:
```bash
mokutil --sb-state
```
If it returns **Secure Boot enabled**, you need to sign VMware modules.

#### **Step 2: Install Required Packages**
Ensure you have the required tools:
```bash
sudo apt update
sudo apt install mokutil openssl
```

#### **Step 3: Generate a Signing Key**
Create a directory and generate the key:
```bash
mkdir -p ~/vmware-keys
cd ~/vmware-keys
openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=VMware Module Signing/"
```

#### **Step 4: Enroll the Key**
Run:
```bash
sudo mokutil --import MOK.der
```
You will be prompted to create a password. **Remember this password**, as you’ll need it after rebooting.

Reboot your system:
```bash
sudo reboot
```
During boot, you’ll enter the **MOK manager**. Select:
1. **Enroll MOK**
2. **Continue**
3. **Yes**
4. Enter the password you set earlier and confirm.

After rebooting, check if the key is enrolled:
```bash
mokutil --list-enrolled | grep VMware
```

#### **Step 5: Sign VMware Modules**
Now sign the `vmmon` and `vmnet` modules:
```bash
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ~/vmware-keys/MOK.priv ~/vmware-keys/MOK.der $(modinfo -n vmmon)
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ~/vmware-keys/MOK.priv ~/vmware-keys/MOK.der $(modinfo -n vmnet)
```

#### **Step 6: Reload the Modules**
```bash
sudo modprobe -r vmmon vmnet
sudo modprobe vmmon
sudo modprobe vmnet
```

#### **Step 7: Verify**
Check if the modules are loaded:
```bash
lsmod | grep vmmon
```
If the output shows `vmmon` and `vmnet`, VMware should now work with Secure Boot enabled.

Let me know if you need further assistance! 🚀