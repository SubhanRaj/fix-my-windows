# Sources & Credits

`fix-my-windows` automates repair techniques that are already publicly documented by
Microsoft — it doesn't invent new fixes. This file lists, module by module, the official
source each one is based on, so nothing on the marketing site links to an unverified URL.

## Microsoft Learn / Microsoft Support

| Module | What it automates | Official source |
|---|---|---|
| [`1_os_repair.bat`](modules/1_os_repair.bat) | `sfc /scannow` + DISM `ScanHealth`/`CheckHealth`/`RestoreHealth` | [SFC command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/sfc) |
| [`2_network_safe.bat`](modules/2_network_safe.bat) | IP/DNS flush, Winsock reset | [Reset TCP/IP](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/reset-tcp-ip-net-shell) |
| [`3_disk_clean.bat`](modules/3_disk_clean.bat) | Temp file purge + `chkdsk` scan on reboot | [CHKDSK command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk) |
| [`4_printer_suite.bat`](modules/4_printer_suite.bat) | Print Spooler reset, Print-to-PDF | [Fix Print Spooler errors](https://support.microsoft.com/en-us/windows/fix-print-spooler-service-not-running-errors-in-windows-bb0de80a-8c4a-4938-a36a-f89a859113f0) |
| [`5_update_reset.bat`](modules/5_update_reset.bat) | Windows Update service/cache reset | [Windows Update troubleshooter](https://support.microsoft.com/en-us/windows/windows-update-troubleshooter-19bc41ca-ad72-ae67-af3c-89ce169755dd) |
| [`6_runtimes_installer.bat`](modules/6_runtimes_installer.bat) | .NET Framework 3.5 via DISM, VC++/.NET Desktop Runtimes | [Deploy .NET Framework 3.5 with DISM](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/deploy-net-framework-35-by-using-deployment-image-servicing-and-management--dism) |
| [`7_sys_info.bat`](modules/7_sys_info.bat) | OS/BIOS export, battery report | [powercfg command-line options](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options) |
| [`8_restore_point.bat`](modules/8_restore_point.bat) | System Restore point creation | [Create a system restore point](https://support.microsoft.com/en-us/windows/create-a-system-restore-point-9557d4f2-ee87-4703-8ba4-5ce2437bd5a4) |
| [`9_defender_audit.bat`](modules/9_defender_audit.bat) | Defender status audit | [Get-MpComputerStatus](https://learn.microsoft.com/en-us/powershell/module/defender/get-mpcomputerstatus) |
| [`10_startup_audit.bat`](modules/10_startup_audit.bat) | Startup program audit | [Configure startup applications](https://support.microsoft.com/en-us/windows/configure-startup-applications-in-windows-115a420a-0bff-4a6f-90e0-1934c844e473) |
| [`12_ram_diagnostics.bat`](modules/12_ram_diagnostics.bat) | Schedules Windows Memory Diagnostic | [Windows Startup Settings](https://support.microsoft.com/en-us/windows/windows-startup-settings-1af6ec8c-4d4a-4b23-adb7-e76eef0b847f) |
| [`13_registry_backup.bat`](modules/13_registry_backup.bat) | Full registry hive export | [Back up and restore the registry](https://support.microsoft.com/en-us/topic/how-to-back-up-and-restore-the-registry-in-windows-855140ad-e318-2a13-2829-d428a2ab0692) |
| [`14_license_activation.bat`](modules/14_license_activation.bat) | Activation status via `slmgr.vbs` | [Slmgr.vbs options](https://learn.microsoft.com/en-us/windows-server/get-started/activation-slmgr-vbs-options) |
| [`15_audio_reset.bat`](modules/15_audio_reset.bat) | Audio service restart | [Fix sound problems in Windows](https://support.microsoft.com/en-us/windows/hardware/audio/fix-sound-or-audio-problems-in-windows) |
| [`16_eventviewer_export.bat`](modules/16_eventviewer_export.bat) | Recent error/warning export | [wevtutil command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wevtutil) |
| [`17_scheduled_tasks.bat`](modules/17_scheduled_tasks.bat) | Scheduled task audit | [schtasks command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks) |
| [`18_gpu_directx.bat`](modules/18_gpu_directx.bat) | GPU driver + DirectX report | [Run DirectX Diagnostic Tool](https://support.microsoft.com/en-za/help/4028644/windows-open-and-run-dxdiagexe) |
| [`19_usb_reset.bat`](modules/19_usb_reset.bat) | USB host controller reset | [Disable-PnpDevice](https://learn.microsoft.com/en-us/powershell/module/pnpdevice/disable-pnpdevice) |
| [`20_display_reset.bat`](modules/20_display_reset.bat) | Display driver reset | [Fix graphics device problems](https://support.microsoft.com/en-us/windows/hardware/display-graphics/fix-graphics-device-problems-with-error-code-43) |
| [`21_bluetooth_reset.bat`](modules/21_bluetooth_reset.bat) | Bluetooth service/profile reset | [Fix Bluetooth problems in Windows](https://support.microsoft.com/en-us/windows/fix-bluetooth-problems-in-windows-723e092f-03fa-858b-5c80-131ec3fba75c) |
| [`22_reboot.bat`](modules/22_reboot.bat) | Scheduled forced restart | [shutdown command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/shutdown) |
| [`22_uac_integrity.bat`](modules/22_uac_integrity.bat) | UAC policy + Secure Boot audit | [UAC settings and configuration](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/settings-and-configuration) |
| [`23_sppsvc_repair.bat`](modules/23_sppsvc_repair.bat) | Software Protection service repair | [Slmgr.vbs options](https://learn.microsoft.com/en-us/windows-server/get-started/activation-slmgr-vbs-options) |
| [`24_network_sharing.bat`](modules/24_network_sharing.bat) | File & printer sharing repair | [File sharing over a network](https://support.microsoft.com/en-us/windows/file-sharing-over-a-network-in-windows-b58704b2-f53a-4b82-7bc1-80f9994725bf) |
| [`25_wifi_manager.bat`](modules/25_wifi_manager.bat) | Wi-Fi profile/key management | [netsh wlan command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-wlan) |
| [`26_safe_mode.bat`](modules/26_safe_mode.bat) | Safe Boot flag toggle | [Windows recovery environment troubleshooting](https://support.microsoft.com/en-us/topic/use-bootrec-exe-in-the-windows-re-to-troubleshoot-startup-issues-902ebb04-daa3-4f90-579f-0fbf51f7dd5d) |
| [`27_firewall_manager.bat`](modules/27_firewall_manager.bat) | Firewall rule management | [netsh advfirewall command reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/netsh-advfirewall) |
| [`28_winpe_usb_creator.bat`](modules/28_winpe_usb_creator.bat) | Bootable WinPE USB creation | [Create WinPE bootable USB drive](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive) |
| [`30_dns_manager.bat`](modules/30_dns_manager.bat) | DNS server switching | [Set-DnsClientServerAddress](https://learn.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress) |
| [`31_time_sync.bat`](modules/31_time_sync.bat) | Windows Time service / NTP resync | [Windows Time service tools and settings](https://learn.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings) |
| [`32_browser_rescue.bat`](modules/32_browser_rescue.bat) | Browser cache/cookie clearing | [Delete cookies in Microsoft Edge](https://support.microsoft.com/en-us/microsoft-edge/delete-cookies-in-microsoft-edge-63947406-40ac-c3b8-57b9-2a946a29ae09) |
| [`33_debloat.bat`](modules/33_debloat.bat) | Telemetry/Appx policy cleanup | [Configure Windows diagnostic data](https://learn.microsoft.com/en-us/windows/privacy/configure-windows-diagnostic-data-in-your-organization) |
| [`WinPE_Rescue.bat`](WinPE_Rescue.bat) | Offline `bootrec`/SFC/DISM from WinPE | [Use Bootrec.exe in Windows RE](https://support.microsoft.com/en-us/topic/use-bootrec-exe-in-the-windows-re-to-troubleshoot-startup-issues-902ebb04-daa3-4f90-579f-0fbf51f7dd5d) |

Some links point to the closest available official page rather than a dedicated article
for that exact feature (e.g. `12_ram_diagnostics.bat` and `26_safe_mode.bat`, where
Microsoft doesn't publish a single stable-URL guide) — noted here rather than left
unlabeled.

## Third-party tools

| Module | Tool | Source |
|---|---|---|
| [`29_hardware_monitor.bat`](modules/29_hardware_monitor.bat) | [LibreHardwareMonitor](https://github.com/LibreHardwareMonitor/LibreHardwareMonitor) (MPL 2.0) | Downloads the latest release directly from its GitHub Releases API — not a Microsoft product. |

Windows, DISM, PowerShell, and related marks are trademarks of Microsoft Corporation.
`fix-my-windows` is an independent, unaffiliated project distributed under the MIT License.
