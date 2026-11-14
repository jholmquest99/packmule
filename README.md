# Packmule: the off-grid AI

Packmule runs on your own computer and keeps working when the internet does not. Load it with your manuals and it answers from them, with the page. Give it jobs and it works in steps, asking before it saves anything. No account, no cloud, and nothing leaves the machine.

**Download page:** https://jholmquest99.github.io/packmule/

## Install

Mac (Apple chip, macOS 13 or newer). Paste into Terminal:

```bash
curl -fsSL https://jholmquest99.github.io/packmule/install.sh | bash
```

Windows 10 or 11. Paste into PowerShell:

```powershell
irm https://jholmquest99.github.io/packmule/install.ps1 | iex
```

Or take the files from the [latest release](https://github.com/jholmquest99/packmule/releases/latest). They are not signed with a paid certificate yet, so a browser download shows a warning; the download page says how to get past it.

## What is in this repository

Only what is needed to download and install the app: the download page, the two install commands, and the installer files under Releases. `SHA256SUMS.txt` in each release lists the checksum of every file, and the install commands check it before installing.

This is a beta. It has been tested on one Mac and has only just reached Windows.

What the app is built from, and the licences: [LICENSES.md](LICENSES.md).
