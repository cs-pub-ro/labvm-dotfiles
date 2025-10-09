#!/bin/bash
# Remote dotfiles downloader and automatic installer
# (downloads a dotfiles repo from git and runs its `install.sh` script)
# Designed to be used inside Lab VMs.
# It is NOT RECOMMENDED to run it on your personal computers!

GIT_URL=${1:-"https://github.com/cs-pub-ro/labvm-dotfiles.git"}
TMP_DIR="/tmp/vm-dotfiles-install"

set -e
rm -rf "$TMP_DIR"
git clone --depth 1 "$GIT_URL" "$TMP_DIR"

(
	cd "$TMP_DIR";
	./install.sh
)

