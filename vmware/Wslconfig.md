# WSL Configuration

## Issue: Nested virtualization is not supported on this machine

To resolve the error, create a file named `%UserProfile%\.wslconfig` on your Windows machine and add the following configuration:

```ini
[wsl2]
nestedVirtualization=false
```

### Create the file using a single command

In PowerShell, run the following command:

```powershell
Set-Content -Path "$env:USERPROFILE\.wslconfig" -Value "[wsl2]`nNestedVirtualization=false"
```

In Command Prompt, run the following command:

```cmd
echo [wsl2]>%UserProfile%\.wslconfig & echo nestedVirtualization=false>>%UserProfile%\.wslconfig
```

For more details, refer to the official documentation:  
[WSL Configuration Documentation](https://learn.microsoft.com/en-us/windows/wsl/wsl-config)