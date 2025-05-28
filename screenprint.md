
### **Taking a Screenshot**
1. **Using the Screenshot Tool (GNOME Screenshot):**
   - Press **Print Screen** (or `PrtSc`) on your keyboard.
   - A screenshot interface appears, allowing you to:
     - Capture the **entire screen**, a **specific window**, or a **selected area**.
     - Choose options via the on-screen prompt.
   - Screenshots are saved by default in the **Pictures/Screenshots** folder.
   - Alternatively, press **Shift + Print Screen** to directly select an area to capture.

2. **Using Keyboard Shortcuts:**
   - **Entire Screen:** `Print Screen` or `Ctrl + Alt + Shift + R` (saves to clipboard).
   - **Active Window:** `Alt + Print Screen`.
   - **Selected Area:** `Shift + Print Screen` or use the screenshot tool.
   - To copy to clipboard instead of saving, add `Ctrl` to any of the above (e.g., `Ctrl + Shift + Print Screen`).

3. **Using the GNOME Shell (GUI):**
   - Press **Print Screen** or access the screenshot tool via the top-right system menu (click the clock or power icon, then select the screenshot option).
   - The interface lets you choose between screenshot or screen recording.

### **Screen Recording**
- **Built-in GNOME Shell Recorder:**
  - Press **Print Screen** or open the screenshot tool from the system menu.
  - Switch to the **screen recording** option (video icon).
  - Select whether to record the **entire screen** or a **specific area**.
  - Click the red record button to start, and stop via the notification in the system tray.
  - Recordings are saved as WebM files in the **Videos** folder.

### **Advanced Options**
- **Install Third-Party Tools:**
  - **Kazam**: Lightweight for screenshots and recordings (`sudo apt install kazam`).
  - **SimpleScreenRecorder**: Great for detailed video capture (`sudo apt install simplescreenrecorder`).
  - **Flameshot**: Customizable screenshot tool (`sudo apt install flameshot`).
- **Command Line:**
  - Use `scrot` for screenshots: `sudo apt install scrot`, then `scrot my_screenshot.png`.
  - For recordings, use `ffmpeg` or `kazam` CLI options.

### **Notes**
- The default screenshot tool in Ubuntu 24.04 is part of the GNOME Shell, replacing older tools like `gnome-screenshot`.
- Ensure your system is updated (`sudo apt update && sudo apt upgrade`) for the latest features.
- Screenshots and recordings can be customized in **Settings > Keyboard > Shortcuts** for different keybindings.
