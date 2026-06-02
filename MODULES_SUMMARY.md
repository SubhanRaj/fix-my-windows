# fix-my-windows: 22-Module Diagnostic Toolkit

## Overview
Complete Windows diagnostic and repair toolkit with 22 specialized modules organized across 3 menu pages. Supports Windows 7 through Windows 11 with intelligent fallbacks for legacy systems.

## Module Organization

### Page 1: Core Repair & Basic Audit (Modules 1-10)
Fundamental system repair and initial diagnostics:
- **[1]** 1_os_repair.bat — SFC scan + DISM image restoration
- **[2]** 2_network_safe.bat — DNS/Winsock reset (preserves static IPs)
- **[3]** 3_disk_clean.bat — Temp file cleanup + CHKDSK scheduling
- **[4]** 4_printer_suite.bat — Spooler reset + Print to PDF enablement
- **[5]** 5_update_reset.bat — Windows Update cache reset
- **[6]** 6_runtimes_installer.bat — .NET Framework 3.5 & VC++ Redistributables
- **[7]** 7_sys_info.bat — Hardware info + battery report export
- **[8]** 8_restore_point.bat — Create system checkpoint (before aggressive repairs)
- **[9]** 9_defender_audit.bat — Windows Defender security status audit
- **[A]** 10_startup_audit.bat — Startup programs & bloatware audit

### Page 2: Advanced Diagnostics (Modules 12-17)
Deep system diagnostics and backups:
- **[B]** 12_ram_diagnostics.bat — Windows Memory Diagnostic (full RAM test)
- **[C]** 13_registry_backup.bat — Full Registry export to /Backups
- **[D]** 14_license_activation.bat — Windows license & activation status
- **[E]** 15_audio_reset.bat — Audio service & driver reset
- **[F]** 16_eventviewer_export.bat — System errors & warnings (last 24h)
- **[G]** 17_scheduled_tasks.bat — Scheduled tasks audit & cleanup

### Page 3: Hardware, Security & Control (Modules 18-22)
Advanced device troubleshooting, security checks, and system reboot:
- **[H]** 18_gpu_directx.bat — GPU & DirectX diagnostics
- **[I]** 19_usb_reset.bat — USB controller reset & driver refresh
- **[J]** 20_display_reset.bat — Display settings safe reset
- **[K]** 21_bluetooth_reset.bat — Bluetooth service & device reset
- **[L]** 22_uac_integrity.bat — UAC settings & admin integrity check
- **[M]** 22_reboot.bat — Deep system reboot (forces immediate restart)

## Menu Navigation
- **Page 1 → Page 2:** Press [N] for Next
- **Page 2 → Page 3:** Press [N] for Next  
- **Page 2 → Page 1:** Press [P] for Previous
- **Page 3 → Page 2:** Press [P] for Previous
- **Anywhere:** Press [Q] to Quit

## Cross-Platform Support
| Windows Version | Status | Notes |
|---|---|---|
| Windows 7 SP1 | ✅ Full | All modules working with WMI/registry fallbacks |
| Windows 8.1 | ✅ Full | All modules working with WMI/registry fallbacks |
| Windows 10 | ✅ Full | All modules with modern PowerShell support |
| Windows 11 | ✅ Full | All modules fully compatible |

## Key Safety Features
- ✅ **System Restore Point:** Create checkpoints before aggressive repairs (Module 8)
- ✅ **Registry Backups:** Full registry export to `/Backups` folder (Module 13)
- ✅ **Static IP Protection:** Network operations preserve static IPs and Group Policy
- ✅ **User Confirmations:** All destructive operations require confirmation
- ✅ **No BSOD Risk:** Zero kernel modifications, no driver corruption
- ✅ **100% Reversible:** All changes can be rolled back via System Restore

## Folder Structure
```
fix-my-windows/
├── Start_Menu.bat         # Main interactive menu (3-page system)
├── README.md              # Full documentation
├── MODULES_SUMMARY.md     # This file
├── LICENSE                # MIT License
└── modules/
    ├── 1_os_repair.bat
    ├── 2_network_safe.bat
    ├── 3_disk_clean.bat
    ├── ... (19 more modules)
    ├── 22_uac_integrity.bat
    └── 22_reboot.bat
```

## Output Locations
- **Reports:** `/Reports/` folder (system info, battery health, security audits)
- **Backups:** `/Backups/` folder (registry backups with timestamps)

## Quick Start
1. Double-click `Start_Menu.bat`
2. Accept UAC elevation prompt
3. Use numeric/letter keys to select modules
4. Navigate between pages with [N]ext and [P]revious
5. Press [Q]uit to exit anytime

## Important Notes
- **Administrator Required:** Scripts auto-elevate but will fail without admin privileges
- **Reboot Required:** Modules 2 (Network), 3 (Disk), 12 (RAM test) require system restart
- **CHKDSK Note:** Module 3 schedules CHKDSK for next boot, doesn't run immediately
- **Print to PDF:** Only enabled on Windows 10+ (skipped gracefully on 7-8.1)
- **Irreversible Changes:** All operations are reversible via System Restore Points
