#!/usr/bin/env bash
set -euo pipefail

SHARE_DIR="$HOME/.local/share"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$SHARE_DIR" "$BIN_DIR"

case "$(uname -m)" in
  x86_64)      assets=("nvim-linux-x86_64.tar.gz" "nvim-linux64.tar.gz") ;;
  aarch64|arm64) assets=("nvim-linux-arm64.tar.gz" "nvim-linux-arm64.zip") ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Find the release asset URL (new naming first, old as fallback)
curl -fsSL -o "$tmp/latest.json" https://api.github.com/repos/neovim/neovim/releases/latest
links=$(grep -oE 'https://github.com/neovim/neovim/releases/download/[^"]+' "$tmp/latest.json")
url=""
for asset in "${assets[@]}"; do
  url=$(grep -F "$asset" <<<"$links" | head -n1) || true
  [ -n "$url" ] && break
done
[ -n "$url" ] || { echo "release asset not found for $(uname -m)" >&2; exit 1; }

echo "fetching: $url"
curl -fsSL -o "$tmp/dl" "$url"

# Extract to temp, then move the top-level dir into ~/.local/share
case "$asset" in
  *.tar.gz) tar -xzf "$tmp/dl" -C "$tmp" ;;
  *.zip)    unzip -oq  "$tmp/dl" -d "$tmp" ;;
esac

install_dir=$(ls -d "$tmp"/*/ | head -n1)
name=$(basename "$install_dir")
rm -rf "$SHARE_DIR/$name"
mv "$install_dir" "$SHARE_DIR/$name"

# Symlink the binary
ln -sf "$SHARE_DIR/$name/bin/nvim" "$BIN_DIR/nvim"
echo "installed: $("$BIN_DIR/nvim" --version | head -n1)"
echo "runtime:   $SHARE_DIR/$name"
echo "symlink:   $BIN_DIR/nvim -> $SHARE_DIR/$name/bin/nvim"

