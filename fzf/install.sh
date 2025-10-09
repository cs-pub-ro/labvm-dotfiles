#!/bin/bash
# Fzf (fuzzy finder) installation script

FZF_TMP="/tmp/fzf-install-src"

set -e
rm -rf "$FZF_TMP" || true
git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_TMP"

# answer "yes" to all prompts
yes | "$FZF_TMP/install"

mkdir -p "$HOME/.local/bin"
cp -f "$FZF_TMP/bin/fzf" "$HOME/.local/bin"

rm -rf "$FZF_TMP"

