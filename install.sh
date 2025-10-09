#!/bin/bash
# Installs the dotfiles for the current user.

# set to "1" for debug info
DEBUG=${DEBUG:-}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
# override using env var to specify alternate vim config
NVIM_CONFIG=${NVIM_CONFIG:-astronvim}

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

rsync "${RSYNC_ARGS[@]}" "$SRC/zsh/" "$XDG_CONFIG_HOME/zsh/"
rm -f "$HOME/"{.zshrc,.zshenv}
ln -sf "$XDG_CONFIG_HOME/zsh/zshrc" "$HOME/.zshrc"
[[ ! -f "$XDG_CONFIG_HOME/zsh/zshenv" ]] || \
	ln -sf "$XDG_CONFIG_HOME/zsh/zshenv" "$HOME/.zshenv"
# run zsh for user to install plugins
zsh -i -c 'source ~/.zshrc; exit 0'

rsync "${RSYNC_ARGS[@]}" "$SRC/nvim/$NVIM_CONFIG/" "$XDG_CONFIG_HOME/nvim/"
# do headless nvim initialization
nvim --headless +q

# tmux config
rsync "${RSYNC_ARGS[@]}" "$SRC/tmux/" "$XDG_CONFIG_HOME/tmux/"

# install fzf
bash "$SRC/fzf/install.sh"
