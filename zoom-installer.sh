#!/usr/bin/env bash
set -euo pipefail

# Zoom installer script for Arch-based distributions
# Usage:
#   ./zoom-installer.sh        # install or update to latest
#   ./zoom-installer.sh --uninstall

ZOOM_URL="https://zoom.us/client/latest/zoom_x86_64.pkg.tar.xz"
PKG_FILE="zoom_x86_64.pkg.tar.xz"

APP_DIR="/opt/zoom"
BIN_LINK="/usr/local/bin/zoom"
DESKTOP_FILE="/usr/share/applications/zoom.desktop"
ICON_PATH="/usr/share/pixmaps/zoom.png"

if [[ "${1-}" == "--uninstall" ]]; then
  echo "[*] Uninstalling Zoom..."
  sudo rm -rf "$APP_DIR" || true
  sudo rm -f "$BIN_LINK" || true
  sudo rm -f "$DESKTOP_FILE" || true
  sudo rm -f "$ICON_PATH" || true
  echo "[+] Done. Zoom removed."
  exit 0
fi

# requirements check
for cmd in curl bsdtar sha256sum awk; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[-] Required command '$cmd' not found. Install it and retry: $cmd" >&2
    exit 1
  fi
done

echo "[*] Installing Zoom dependencies (requires sudo)..."
# Pulseaudio conflicts with PipeWire, so we skip it here.
sudo pacman -S --needed --noconfirm qt5-svg qt5-x11extras libxcb mesa

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT
cd "$workdir"

echo "[*] Downloading Zoom package..."
curl -fsSL "$ZOOM_URL" -o "$PKG_FILE"

echo "[*] Extracting package..."
bsdtar -xf "$PKG_FILE"

if [[ ! -d opt/zoom ]]; then
  echo "[-] Unexpected package structure: opt/zoom not found." >&2
  exit 1
fi

echo "[*] Installing into ${APP_DIR} (requires sudo)..."
sudo rm -rf "$APP_DIR"
sudo mkdir -p "$APP_DIR"
sudo cp -r opt/zoom/* "$APP_DIR/"

# sandbox fix (like Chrome/VS Code style)
if [[ -f "$APP_DIR/chrome-sandbox" ]]; then
  sudo chown root:root "$APP_DIR/chrome-sandbox" || true
  sudo chmod 4755 "$APP_DIR/chrome-sandbox" || true
fi

echo "[*] Creating wrapper script ${BIN_LINK}..."
sudo mkdir -p "$(dirname "$BIN_LINK")"
cat <<'EOF' | sudo tee "$BIN_LINK" >/dev/null
#!/bin/bash
export LD_LIBRARY_PATH=/opt/zoom:$LD_LIBRARY_PATH
exec /opt/zoom/ZoomLauncher "$@"
EOF
sudo chmod +x "$BIN_LINK"

echo "[*] Installing .desktop file..."
cat <<EOF | sudo tee "$DESKTOP_FILE" >/dev/null
[Desktop Entry]
Name=Zoom
Exec=/usr/local/bin/zoom %U
Icon=zoom
Type=Application
Categories=Network;VideoConference;
EOF

echo "[*] Installing icon..."
if [[ -f "$APP_DIR/zoom.png" ]]; then
  sudo install -Dm644 "$APP_DIR/zoom.png" "$ICON_PATH"
fi

# detect version
if [[ -f "$APP_DIR/version.txt" ]]; then
  VERSION=$(cat "$APP_DIR/version.txt")
  echo "[+] Installed Zoom version: $VERSION"
fi

echo
echo "[+] Zoom installed successfully."
echo "[*] Run:  zoom"
echo "[*] To uninstall:  $0 --uninstall"
