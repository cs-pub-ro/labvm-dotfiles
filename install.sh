#!/bin/bash
# Installs the dotfiles for the current user.

# set to "1" for debug info
DEBUG=${DEBUG:-}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

set -eo pipefail
SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# System prerequisites check
for cmd in rsync wget git; do
	if ! command -v "$cmd" &> /dev/null; then
		echo "$cmd was not found (required)!" >&2; exit 1
	fi
done

# Prerequisites: download the fetch.sh utility
mkdir -p ~/.local/bin
wget -O ~/.local/bin/fetch.sh "https://raw.githubusercontent.com/niflostancu/release-fetch-script/master/fetch.sh"
chmod +x ~/.local/bin/fetch.sh
export PATH="$HOME/.local/bin/:$PATH"

# Install each component using rsync
RSYNC_ARGS=(-ah --mkpath)
if [[ "$DEBUG" -ge 1 ]]; then RSYNC_ARGS+=(-v); fi

rsync "${RSYNC_ARGS[@]}" "$SRC/bash/" "$XDG_CONFIG_HOME/bash/"
rm -f "$HOME/.bashrc"
ln -sf "$XDG_CONFIG_HOME/bash/bashrc" "$HOME/.bashrc"

