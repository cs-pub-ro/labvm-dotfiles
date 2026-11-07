#!/bin/bash
# Installs the dotfiles for the current user.

# set to "1" for debug info
DEBUG=${DEBUG:-}
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
# default components to install
COMPONENTS=(fetch bash zsh nvim tmux fzf)
COMP_OVERRIDE=()
# parse arguments
while [ $# -gt 0 ]; do
	case "$1" in
		-*) COMPONENTS=( "${COMPONENTS[@]/${1:1}}" ) ;;
		+*) COMPONENTS+=( "${1:1}" );;
		*) COMP_OVERRIDE+=( "$1" );;
	esac; shift
done
if [[ "${#COMP_OVERRIDE[@]}" -gt 0 ]]; then
	COMPONENTS=( "${COMP_OVERRIDE[@]}" )
fi

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
export PATH="$HOME/.local/bin/:$PATH"
if [[ " ${COMPONENTS[*]} " =~ " fetch " ]]; then
	wget -O ~/.local/bin/fetch.sh "https://raw.githubusercontent.com/niflostancu/release-fetch-script/master/fetch.sh"
	chmod +x ~/.local/bin/fetch.sh
fi

# Install each component using rsync
RSYNC_ARGS=(-ah --mkpath)
if [[ "$DEBUG" -ge 1 ]]; then RSYNC_ARGS+=(-v); fi

if [[ " ${COMPONENTS[*]} " =~ " bash " ]]; then
	rsync "${RSYNC_ARGS[@]}" "$SRC/bash/" "$XDG_CONFIG_HOME/bash/"
	rm -f "$HOME/.bashrc"
	ln -sf "$XDG_CONFIG_HOME/bash/bashrc" "$HOME/.bashrc"
fi

if [[ " ${COMPONENTS[*]} " =~ " zsh " ]]; then
	rsync "${RSYNC_ARGS[@]}" "$SRC/zsh/" "$XDG_CONFIG_HOME/zsh/"
	rm -f "$HOME/"{.zshrc,.zshenv}
	ln -sf "$XDG_CONFIG_HOME/zsh/zshrc" "$HOME/.zshrc"
	[[ ! -f "$XDG_CONFIG_HOME/zsh/zshenv" ]] || \
		ln -sf "$XDG_CONFIG_HOME/zsh/zshenv" "$HOME/.zshenv"
	# run zsh for user to install plugins
	zsh -i -c 'source ~/.zshrc; exit 0'
fi

if [[ " ${COMPONENTS[*]} " =~ " nvim " ]]; then
	# first, install latest nvim for user (in ~/.local/bin)
	"$SRC/scripts/install-nvim.sh"
	# vanilla nvim (no config) + one dir per alternative config
	mkdir -p "$XDG_CONFIG_HOME/nvim"
	rsync "${RSYNC_ARGS[@]}" "$SRC/nvim/lazyvim/" "$XDG_CONFIG_HOME/nvim-lazyvim/"
	rsync "${RSYNC_ARGS[@]}" "$SRC/nvim/astronvim/" "$XDG_CONFIG_HOME/nvim-astronvim/"
	# install the config chooser (function defined in the rc files)
	install -m 755 "$SRC/scripts/lab-choose-nvim" "$HOME/.local/bin/lab-choose-nvim"
fi

# tmux config
if [[ " ${COMPONENTS[*]} " =~ " tmux " ]]; then
	rsync "${RSYNC_ARGS[@]}" "$SRC/tmux/" "$XDG_CONFIG_HOME/tmux/"
fi

# install fzf
if [[ " ${COMPONENTS[*]} " =~ " fzf " ]]; then
	bash "$SRC/fzf/install.sh"
fi
