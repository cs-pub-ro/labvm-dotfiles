#!/usr/bin/env bash
set -euo pipefail

SHARE_DIR="$HOME/.local/share"
BIN_DIR="$HOME/.local/bin"
NAME="zsh-patina"
mkdir -p "$SHARE_DIR" "$BIN_DIR"

case "$(uname -m)" in
  x86_64)        assets=("x86_64-unknown-linux-gnu" "x86_64-unknown-linux-musl") ;;
  aarch64|arm64) assets=("aarch64-unknown-linux-gnu" "aarch64-unknown-linux-musl") ;;
  armv7l)        assets=("arm-unknown-linux-gnueabihf" "arm-unknown-linux-musleabihf") ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Find the release asset URL (glibc first, musl as fallback)
curl -fsSL -o "$tmp/latest.json" https://api.github.com/repos/michel-kraemer/zsh-patina/releases/latest
links=$(grep -oE 'https://github.com/michel-kraemer/zsh-patina/releases/download/[^"]+' "$tmp/latest.json")
url=""
for asset in "${assets[@]}"; do
  url=$(grep -F "${NAME}-v" <<<"$links" | grep -F "${asset}.tar.gz" | head -n1) || true
  [ -n "$url" ] && break
done
[ -n "$url" ] || { echo "release asset not found for $(uname -m)" >&2; exit 1; }

echo "fetching: $url"
curl -fsSL -o "$tmp/dl" "$url"
tar -xzf "$tmp/dl" -C "$tmp"

# Move the top-level dir into ~/.local/share and symlink the binary
install_dir=$(ls -d "$tmp"/*/ | head -n1)
rm -rf "$SHARE_DIR/$NAME"
mv "$install_dir" "$SHARE_DIR/$NAME"
ln -sf "$SHARE_DIR/$NAME/$NAME" "$BIN_DIR/$NAME"
echo "installed: $("$BIN_DIR/$NAME" --version)"
echo "runtime:   $SHARE_DIR/$NAME"
echo "symlink:   $BIN_DIR/$NAME -> $SHARE_DIR/$NAME/$NAME"
