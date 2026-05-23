#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
    local src="$1" dst="$2"
    [ ! -e "$src" ] && return

    mkdir -p "$(dirname "$dst")"
    ln -sfn "$src" "$dst"
    echo "  $dst -> $(basename "$src")"
}

info "Syncing Homebrew packages..."
brew bundle

info "Syncing dotfiles..."
for src in "$REPO"/ssh/*; do
    symlink "$src" "$HOME/.ssh/$(basename "$src")"
done
symlink "$REPO/git/.gitconfig"       "$HOME/.gitconfig"
symlink "$REPO/git/.gitignore"       "$HOME/.gitignore"
symlink "$REPO/zsh/.zshrc"           "$HOME/.zshrc"
symlink "$REPO/ghostty/config"       "$HOME/.config/ghostty/config"
symlink "$REPO/starship/config.toml" "$HOME/.config/starship.toml"
symlink "$REPO/mise"                 "$HOME/.config/mise"

info "Syncing Cursor settings..."
symlink "$REPO/cursor/settings.json"    "$HOME/Library/Application Support/Cursor/User/settings.json"
symlink "$REPO/cursor/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"
while read -r ext; do
    cursor --install-extension "$ext" --force
done < "$REPO/cursor/extensions.txt"

info "Syncing VS Code settings..."
symlink "$REPO/vscode/settings.json"    "$HOME/Library/Application Support/Code/User/settings.json"
symlink "$REPO/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
while read -r ext; do
    code --install-extension "$ext" --force
done < "$REPO/vscode/extensions.txt"

success "Setup complete!"
