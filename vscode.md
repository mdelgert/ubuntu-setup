# VSCODE notes
How to increase terminal font size

## Increase Terminal Font Size

There are several ways to increase the terminal font size in VS Code:

### Method 1: Using Settings UI
1. Open Settings (`Ctrl+,` or `Cmd+,`)
2. Search for "terminal font size"
3. Look for "Terminal › Integrated: Font Size"
4. Change the value (default is usually 14)

### Method 2: Using Settings JSON
1. Open Settings JSON (`Ctrl+Shift+P` → "Preferences: Open Settings (JSON)")
2. Add or modify this setting:
```json
{
    "terminal.integrated.fontSize": 16
}
```

### Method 3: Using Keyboard Shortcuts
- **Increase font size**: `Ctrl+Plus` (or `Cmd+Plus` on Mac)
- **Decrease font size**: `Ctrl+Minus` (or `Cmd+Minus` on Mac)
- **Reset font size**: `Ctrl+0` (or `Cmd+0` on Mac)

### Method 4: Using Command Palette
1. Open Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Type "Terminal: Select Default Profile"
3. Or search for font-related terminal commands

### Additional Terminal Font Settings
You can also customize other terminal font properties:
```json
{
    "terminal.integrated.fontSize": 16,
    "terminal.integrated.fontFamily": "Fira Code, Consolas, monospace",
    "terminal.integrated.fontWeight": "normal",
    "terminal.integrated.lineHeight": 1.2
}
```

**Note**: The keyboard shortcuts (Method 3) work immediately and are the quickest way to adjust font size on the fly.
