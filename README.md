# fix-my-windows 🛠️

A fast, modular, and CLI-based diagnostic toolkit for Windows. Designed for IT professionals, system administrators, and power users who need a reliable, repeatable way to fix corrupted Windows images, clear temporary files, and reset network stacks without destroying custom configurations.

## Features
* **Auto-Elevation:** Scripts automatically request UAC Admin privileges—no need to manually open an elevated command prompt.
* **Modular Design:** A central menu system (`Start_Menu.bat`) calls individual modules, making it easy to add new features or run scripts individually.
* **Safe Network Reset:** Flushes DNS and resets Winsock without wiping out manually assigned static IP addresses.
* **Deep OS Repair:** Chains `sfc /scannow` with `DISM` cleanup and online restoration to fix deep-seated Windows Update and image corruption.
* **Printer Repair Suite:** Resets spooler service and enables Print to PDF feature.
* **Runtimes Installer:** One-click enablement of .NET Framework 3.5 and latest Visual C++ Redistributables (x86 & x64).
* **System Info Export:** Auto-generates hardware reports and battery health reports to a `/Reports` folder.
* **Disk Maintenance:** Advanced cleanup with user confirmation safeguards before aggressive operations (Recycle Bin, caches, etc.).
* **USB-Ready:** Completely portable. Drop the folder on a flash drive and run it on any target machine.

## Folder Structure
```text
fix-my-windows/
├── Start_Menu.bat         # Main interactive menu (Run this!)
├── README.md              # This file
├── LICENSE                # MIT License
├── .gitignore             # Git configuration
├── .gitattributes         # CRLF line ending config for batch files
└── modules/
    ├── 1_os_repair.bat           # SFC, WinSxS cleanup, and DISM restore
    ├── 2_network_safe.bat        # Safe DNS/Winsock reset (ignores static IPs)
    ├── 3_disk_clean.bat          # Temp file purge with safeguard + live CHKDSK
    ├── 4_printer_suite.bat       # Spooler reset + Print to PDF enablement
    ├── 5_update_reset.bat        # Windows Update cache reset
    ├── 6_runtimes_installer.bat  # .NET Framework 3.5 & VC++ Redistributables installer
    ├── 7_sys_info.bat            # Hardware/battery info expor

## Module Reference

| Module | Description |
|--------|-------------|
| **[1] OS Repair** | Runs `sfc /scannow` followed by DISM WinSxS cleanup and online system restoration. Best for corrupted Windows images. |
| **[2] Network Safe** | Flushes DNS cache, re-registers DNS, releases and renews DHCP, and resets Winsock. Preserves static IP configurations. |
| **[3] Disk Cleanup** | Clears temp folders with user confirmation, enables deep cleanmgr utility for Recycle Bin/caches, and runs live CHKDSK. |
| **[4] Printer Suite** | Stops and restarts Print Spooler service, clears stuck print jobs, and enables Print to PDF feature. |
| **[5] Update Reset** | (Placeholder module—customize as needed for Windows Update troubleshooting) |
| **[6] Runtimes** | Sub-menu to enable .NET Framework 3.5 or download/install latest Visual C++ Redistributables (x86 & x64). |
| **[7] System Info** | Exports PC name, serial number, OS version, and IP config to `/Reports` folder; generates battery health report. Auto-opens Reports in Explorer. |
| **[8] Deep Reboot** | Forces immediate system restart with confirmation prompt. Closes all applications and bypasses Fast Startup. |ter (auto-opens Reports)
    └── 8_reboot.bat              # Deep kernel cold boot (bypass Fast Startup)
```

## How to Use
1. Download or clone this repository to your local machine or a USB drive.
2. Double-click `Start_Menu.bat`.
3. Accept the UAC prompt for Administrator privileges.
4. Select the module you want to run from the interactive menu.

## Development Note (Mac / Linux Users)
If you are contributing to this repository using VS Code on macOS or Linux, **ensure your line endings are set to CRLF**. Saving batch files with LF line endings will break the `goto` labels in the Windows Command Prompt.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing
Contributions are welcome! If you have an idea for a new module (e.g., hardware diagnostics, print spooler reset), feel free to fork the repository and submit a pull request.