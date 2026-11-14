#!/bin/bash
# Packmule, the off-grid AI: installer for Mac.
#
#   curl -fsSL https://jholmquest99.github.io/packmule/install.sh | bash
#
# What it does, in order:
#   1. downloads the Packmule disk image from this project's latest release
#   2. checks the download against its published checksum
#   3. copies Packmule.app into Applications (your own Applications folder if the main one is locked)
#   4. opens it
# It never asks for a password and changes nothing else on the computer.
# Your chats, files and models live in ~/Library/Application Support/Packmule and are left alone on a reinstall.
set -euo pipefail

REPO="jholmquest99/packmule"
BASE="${PACKMULE_BASE:-https://github.com/$REPO/releases/latest/download}"      # the three PACKMULE_ settings exist for testing this script
FILE="Packmule-mac.dmg"
MNT=""
TMP=""

say()  { printf '\033[38;5;208m==>\033[0m %s\n' "$1"; }
fail() { printf '\033[31mStopped:\033[0m %s\n' "$1" >&2; exit 1; }
tidy() { [ -n "$MNT" ] && hdiutil detach "$MNT" -quiet 2>/dev/null || true; [ -n "$TMP" ] && rm -rf "$TMP"; }
trap tidy EXIT

[ "$(uname -s)" = "Darwin" ] || fail "This command is for Mac. On Windows, use the PowerShell command on the download page."
[ "$(uname -m)" = "arm64" ]  || fail "Packmule needs a Mac with an Apple chip (M1 or newer). This Mac has an Intel chip."
[ "$(sw_vers -productVersion | cut -d. -f1)" -ge 13 ] || fail "Packmule needs macOS 13 or newer."
if pgrep -f "Packmule.app/Contents/MacOS/Packmule" >/dev/null 2>&1; then
  fail "Packmule is open. Quit it, then run this command again."
fi

TMP="$(mktemp -d)"
say "Downloading Packmule (about 250 MB)"
curl -fL --progress-bar -o "$TMP/$FILE" "$BASE/$FILE" || fail "The download did not finish. Check the internet connection and try again."
curl -fsSL -o "$TMP/SHA256SUMS.txt" "$BASE/SHA256SUMS.txt" || fail "Could not fetch the checksum list. Try again."

say "Checking the download"
WANT="$(awk -v f="$FILE" '$2 == f {print $1}' "$TMP/SHA256SUMS.txt")"
GOT="$(shasum -a 256 "$TMP/$FILE" | awk '{print $1}')"
[ -n "$WANT" ] && [ "$WANT" = "$GOT" ] || fail "The download does not match its checksum, so it was not installed. Try again."

say "Installing"
MNT="$(hdiutil attach "$TMP/$FILE" -nobrowse -readonly | awk -F'\t' '/\/Volumes\// {print $NF}' | tail -1)"
[ -d "$MNT/Packmule.app" ] || fail "The disk image did not contain Packmule."
DEST="${PACKMULE_DEST:-/Applications}"
if [ ! -w "$DEST" ]; then DEST="$HOME/Applications"; mkdir -p "$DEST"; fi
rm -rf "$DEST/Packmule.app"
ditto "$MNT/Packmule.app" "$DEST/Packmule.app"
xattr -dr com.apple.quarantine "$DEST/Packmule.app" 2>/dev/null || true

say "Installed in $DEST. Opening Packmule"
say "The first time it opens it downloads a starter model (about 4.6 GB). After that it needs no internet."
[ -n "${PACKMULE_NO_OPEN:-}" ] || open "$DEST/Packmule.app"
