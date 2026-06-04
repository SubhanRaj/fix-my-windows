# fix-my-windows 🛠️

A fast, modular, and CLI-based diagnostic toolkit for Windows. Designed for IT professionals, system administrators, and power users who need a reliable, repeatable way to fix corrupted Windows images, clear temporary files, and reset network stacks without destroying custom configurations.

## Features
* **Auto-Elevation:** Scripts automatically request UAC Admin privileges—no need to manually open an elevated command prompt.
* **Modular Design:** A central menu system (`Start_Menu.bat`) with 22 diagnostic modules, easily paginated for navigation.
* **Safe Network Reset:** Flushes DNS and resets Winsock without wiping out manually assigned static IPs or Group Policy.
* **Deep OS & Hardware Repair:** System file checking, DISM restoration, driver resets, USB/Bluetooth/Audio troubleshooting.
* **Comprehensive Diagnostics:** RAM testing, GPU/DirectX info, Event Viewer errors, security audits, license status.
* **System Backup & Recovery:** Automatic system restore points, registry backups, scheduled tasks audit before aggressive repairs.
* **Cross-Platform:** Full Windows 7-11 support with intelligent fallbacks for legacy systems.
* **No Group Policy Modifications:** Respects domain-level configurations and enterprise settings.
* **100% Reversible:** All changes backed by system restore points; no data loss operations.
* **USB-Ready:** Completely portable. Drop the folder on a flash drive and run it anywhere.

## Folder Structure
```text
fix-my-windows/
├── Start_Menu.bat                 # Main interactive menu (3-page paginated menu)
├── README.md                      # This file
├── LICENSE                        # MIT License
├── .gitignore                     # Git configuration
├── .gitattributes                 # CRLF line ending config for batch files
└── modules/
    ├── 1_os_repair.bat            # SFC, WinSxS cleanup, and DISM restore
    ├── 2_network_safe.bat         # DNS/Winsock reset (preserves static IPs)
    ├── 3_disk_clean.bat           # Temp purge + CHKDSK with safeguards
    ├── 4_printer_suite.bat        # Spooler reset + Print to PDF
    ├── 5_update_reset.bat         # Windows Update cache reset
    ├── 6_runtimes_installer.bat   # .NET 3.5 & VC++ Redists (Windows 7-11)
    ├── 7_sys_info.bat             # Hardware/battery info exporter
    ├── 8_restore_point.bat        # Create system restore checkpoint
    ├── 9_defender_audit.bat       # Windows Defender security audit
    ├── 10_startup_audit.bat       # Startup programs audit
    ├── 11_reboot.bat              # Deep system reboot
    ├── 12_ram_diagnostics.bat     # Windows Memory Diagnostic
    ├── 13_registry_backup.bat     # Full Registry backup
    ├── 14_license_activation.bat  # Windows license & activation status
    ├── 15_audio_reset.bat         # Audio service/driver reset
    ├── 16_eventviewer_export.bat  # System errors and warnings export
    ├── 17_scheduled_tasks.bat     # Scheduled tasks audit
    ├── 18_gpu_directx.bat         # GPU and DirectX diagnostics
    ├── 19_usb_reset.bat           # USB controller reset
    ├── 20_display_reset.bat       # Display settings safe reset
    ├── 21_bluetooth_reset.bat     # Bluetooth service reset
    └── 22_uac_integrity.bat       # UAC and system integrity check

```

## How to Use
1. Download or clone this repository to your local machine or a USB drive.
2. Double-click `Start_Menu.bat`.
3. Accept the UAC prompt for Administrator privileges.
4. Select the module you want to run from the interactive menu.

## Module Reference (22 Modules)

### Core System Repair (Modules 1-5)
| Module | Description |
|--------|-------------|
| **[1] OS Repair** | Runs `sfc /scannow` followed by DISM WinSxS cleanup and online restoration. Best for corrupted Windows images and system corruption. |
| **[2] Network Safe** | Flushes DNS, re-registers DNS, renews DHCP, resets Winsock. **Preserves static IP and Group Policy settings.** Requires reboot. |
| **[3] Disk Cleanup** | Clears temp folders (user confirmed), runs deep cleanmgr for Recycle Bin/caches, schedules CHKDSK for next boot. |
| **[4] Printer Suite** | Resets Print Spooler service, clears stuck jobs. Enables Print to PDF on Windows 10+ (gracefully skipped on 7-8.1). |
| **[5] Update Reset** | Safely resets Windows Update cache by stopping services, clearing SoftwareDistribution and Catroot2, then restarting. |

### System Optimization & Backup (Modules 6-10)
| Module | Description |
|--------|-------------|
| **[6] Runtimes** | Sub-menu: Enable .NET Framework 3.5 OR install Visual C++ Redistributables (x86/x64) via Microsoft permalinks. |
| **[7] System Info** | Exports hardware serial number, OS version, IP configuration, and battery health report to `/Reports` folder. Auto-opens Explorer. |
| **[8] Restore Point** | Creates system checkpoint before aggressive repairs. Hybrid method: PowerShell (Win 10+) or WMIC (Win 7-8.1). Risk-free rollback. |
| **[9] Defender Audit** | Windows Defender status: engine state, real-time protection, signature updates, threat history. Windows 10+ detailed, Win 7-8.1 WMI fallback. |
| **[10] Startup Audit** | Lists startup programs from Startup folder and HKLM/HKCU Run registry. Provides bloatware identification guidance. |

### System Diagnostics & Audit (Modules 11-16)
| Module | Description |
|--------|-------------|
| **[11] Reboot** | Force immediate reboot with confirmation. Closes all apps, bypasses Fast Startup. Used after system repairs. |
| **[12] RAM Diagnostics** | Launches Windows Memory Diagnostic. Schedules comprehensive RAM test for next reboot (10-30 minutes). Detects bad memory. |
| **[13] Registry Backup** | Full Registry backup: HKLM, HKCU, HKCR, HKCC. Saves .reg files to `/Backups` folder. Enables disaster recovery. |
| **[14] License Status** | Exports Windows activation status, product version, build number, and license details. Shows license validity. |
| **[15] Audio Reset** | Comprehensive audio troubleshooting: restarts services (audiosrv, mmcss), clears caches, provides driver update guidance. |
| **[16] Event Viewer** | Exports critical/error events from last 24 hours from System and Application logs. Helps diagnose system problems. |

### Drivers, Hardware & Security (Modules 17-22)
| Module | Description |
|--------|-------------|
| **[17] Scheduled Tasks** | Non-destructive audit of scheduled tasks. Reports problematic, failed, or orphaned tasks for manual review/disable. |
| **[18] GPU/DirectX** | Comprehensive GPU diagnostics. Shows driver version, display adapters, monitors, and DirectX info. Exports to `/Reports`. |
| **[19] USB Reset** | Disables/enables USB controllers and hubs. Fixes undetected USB devices. Uses PowerShell on Windows 10+, device manager on 7-8.1. |
| **[20] Display Reset** | Resets display drivers to safe defaults. Fixes corrupted display settings and resolution issues. |
| **[21] Bluetooth Reset** | Stops/restarts Bluetooth service, clears device cache. Fixes Bluetooth connectivity and pairing issues. |
| **[22] UAC Integrity** | Comprehensive UAC audit: EnableLUA status, consent prompt level, secure desktop, admin accounts, privilege elevation settings. |

## Navigation
The main menu is paginated into 3 pages:
- **Page 1:** Modules 1-10 (Core repair + backups & basic audits)
- **Page 2:** Modules 11-16 (Deep diagnostics, registry, and logs)
- **Page 3:** Modules 17-22 (Hardware troubleshooting & security)

Use **N** to go to the next page, **P** for previous page, and **Q** to quit anytime.

## Output Locations
- **Reports:** `/Reports/` folder (system info, battery health, security audits)
- **Backups:** `/Backups/` folder (registry backups with timestamps)

## Important Notes
- **Administrator Required:** Scripts auto-elevate but will fail without admin privileges.
- **Reboot Required:** Modules 2 (Network), 3 (Disk), and 12 (RAM test) require a system restart.
- **CHKDSK Note:** Module 3 schedules CHKDSK for the next boot; it does not run immediately.
- **Print to PDF:** Only enabled on Windows 10+ (skipped gracefully on 7-8.1).
- **Irreversible Changes:** All operations are reversible via System Restore Points (Module 8).

## Safety & Compliance Notes

✅ **Static IP Protection:** Network operations preserve manually assigned static IPs. DHCP commands ignored on static configs.

✅ **Group Policy Compliance:** No gpedit or GPO modifications. Enterprise domain settings respected.

✅ **Restore Point Safety:** Module 8 creates checkpoint before aggressive ops. All changes reversible.

✅ **Windows 7-11 Compatible:** All 22 modules support Windows 7 through 11 with intelligent fallbacks.

✅ **No Registry Corruption:** Registry operations use read-only `reg query` for audits. No aggressive modifications.

✅ **Reversible Operations:** Every module includes user confirmation. No silent destructive actions.

✅ **No BSOD Risk:** Zero kernel modifications, no driver corruption, no system instability issues.

## Development Note (Mac / Linux Users)
If you are contributing to this repository using VS Code on macOS or Linux, **ensure your line endings are set to CRLF**. Saving batch files with LF line endings will break the `goto` labels in the Windows Command Prompt.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing
Contributions are welcome! If you have an idea for a new module (e.g., hardware diagnostics, print spooler reset), feel free to fork the repository and submit a pull request. Please ensure your code follows the existing modular structure and includes appropriate safety checks and user confirmations.