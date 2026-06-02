# fix-my-windows 🛠️

A fast, modular, and CLI-based diagnostic toolkit for Windows. Designed for IT professionals, system administrators, and power users who need a reliable, repeatable way to fix corrupted Windows images, clear temporary files, and reset network stacks without destroying custom configurations.

## Features
* **Auto-Elevation:** Scripts automatically request UAC Admin privileges—no need to manually open an elevated command prompt.
* **Modular Design:** A central menu system (`Start_Menu.bat`) calls individual modules, making it easy to add new features or run scripts individually.
* **Safe Network Reset:** Flushes DNS and resets Winsock without wiping out manually assigned static IP addresses.
* **Deep OS Repair:** Chains `sfc /scannow` with `DISM` cleanup and online restoration to fix deep-seated Windows Update and image corruption.
* **USB-Ready:** Completely portable. Drop the folder on a flash drive and run it on any target machine.

## Folder Structure
```text
fix-my-windows/
├── Start_Menu.bat         # The main interactive menu (Run this!)
└── modules/
    ├── 1_os_repair.bat    # SFC, WinSxS cleanup, and DISM restore
    ├── 2_network_safe.bat # Safe DNS/Winsock reset (ignores static IPs)
    ├── 3_disk_clean.bat   # Temp file purge and live CHKDSK
    └── 4_reboot.bat       # Deep kernel cold boot (bypass Fast Startup)
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