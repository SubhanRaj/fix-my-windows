# =================================================================
# fix-my-windows Bootstrap Loader (Windows 7 - 11 Compatible)
# =================================================================

# Force TLS 1.2 connection for older OS versions
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

Write-Host "Downloading fix-my-windows toolkit..." -ForegroundColor Cyan

$tempDir = Join-Path $env:TEMP "fmw-deploy"
$zipPath = Join-Path $env:TEMP "fmw.zip"
$repoUrl = "https://github.com/SubhanRaj/fix-my-windows/archive/refs/heads/main.zip"

# Clean up previous runs
if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force }
if (Test-Path $zipPath) { Remove-Item -Path $zipPath -Force }
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

# Download ZIP using Windows 7 compatible WebClient
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($repoUrl, $zipPath)

Write-Host "Extracting modules..." -ForegroundColor Cyan

# Unzip using native Shell COM Object (avoids missing Expand-Archive cmdlet)
$shell = New-Object -ComObject Shell.Application
$zipArchive = $shell.NameSpace($zipPath)
$destination = $shell.NameSpace($tempDir)
$destination.CopyHere($zipArchive.Items(), 16) # 16 = Hide progress dialog / Yes to all

# Locate the extracted folder
$extractFolder = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
$startMenu = Join-Path $extractFolder.FullName "Start_Menu.bat"

Write-Host "Launching IT Diagnostic Toolkit..." -ForegroundColor Green

# Execute the toolkit
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$startMenu`"" -Wait

Write-Host "Cleaning up temporary files..." -ForegroundColor Cyan
Remove-Item -Path $zipPath -Force
Remove-Item -Path $tempDir -Recurse -Force