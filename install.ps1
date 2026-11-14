# Packmule, the off-grid AI: installer for Windows 10 and 11.
#
#   irm https://jholmquest99.github.io/packmule/install.ps1 | iex
#
# What it does, in order:
#   1. downloads the Packmule setup program from this project's latest release
#   2. checks the download against its published checksum
#   3. installs Packmule for your user only (no administrator password)
#   4. opens it
# Your chats, files and models live in %LOCALAPPDATA%\Packmule and are left alone on a reinstall.
$ErrorActionPreference = "Stop"
$repo = "jholmquest99/packmule"
$base = "https://github.com/$repo/releases/latest/download"
$file = "Packmule-Setup.exe"

function Say($text) { Write-Host "==> " -ForegroundColor DarkYellow -NoNewline; Write-Host $text }

if (-not [Environment]::Is64BitOperatingSystem) { throw "Packmule needs 64-bit Windows 10 or 11." }
if (Get-Process -Name Packmule -ErrorAction SilentlyContinue) { throw "Packmule is open. Close it, then run this command again." }

$tmp = Join-Path $env:TEMP ("packmule-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
    $ProgressPreference = "SilentlyContinue"        # the built-in progress bar makes downloads many times slower
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $exe = Join-Path $tmp $file
    $sums = Join-Path $tmp "SHA256SUMS.txt"
    Say "Downloading Packmule (about 40 MB)"
    Invoke-WebRequest -Uri "$base/$file" -OutFile $exe -UseBasicParsing
    Invoke-WebRequest -Uri "$base/SHA256SUMS.txt" -OutFile $sums -UseBasicParsing

    Say "Checking the download"
    $want = $null
    foreach ($line in Get-Content $sums) {
        $parts = $line.Trim() -split "\s+"
        if ($parts.Count -ge 2 -and $parts[1] -eq $file) { $want = $parts[0].ToLower() }
    }
    $got = (Get-FileHash -Algorithm SHA256 -Path $exe).Hash.ToLower()
    if (-not $want -or $want -ne $got) { throw "The download does not match its checksum, so it was not installed. Try again." }

    Say "Installing"
    $p = Start-Process -FilePath $exe -ArgumentList "/VERYSILENT", "/SUPPRESSMSGBOXES", "/NORESTART" -Wait -PassThru
    if ($p.ExitCode -ne 0) { throw "The setup program stopped with code $($p.ExitCode)." }

    $app = Join-Path $env:LOCALAPPDATA "Programs\Packmule\Packmule.exe"
    if (-not (Test-Path $app)) { throw "Setup finished but Packmule was not found at $app." }

    # The window is drawn by Microsoft Edge WebView2, which Windows 11 has built in. Say so plainly if it is missing.
    $wv = "{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}"
    $has = (Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\$wv") -or (Test-Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\$wv") -or (Test-Path "HKCU:\SOFTWARE\Microsoft\EdgeUpdate\Clients\$wv")
    if (-not $has) {
        Say "One more thing is needed: Microsoft Edge WebView2. Get it from https://developer.microsoft.com/microsoft-edge/webview2 (the Evergreen installer), then open Packmule from the Start menu."
    } else {
        Say "Installed. Opening Packmule"
        Say "The first time it opens it downloads its engine and a starter model (about 6 GB in all). After that it needs no internet."
        Start-Process -FilePath $app
    }
} finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
}
