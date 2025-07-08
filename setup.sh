#!/bin/bash

set -ex

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle

# git
ln -sf "$(pwd)/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$(pwd)/git/.gitignore" "$HOME/.gitignore"

# zsh
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$(pwd)/zsh/.zshenv" "$HOME/.zshenv"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ghostty
ln -sf "$(pwd)/ghostty/config" "$HOME/.config/ghostty/config"

# starship
ln -sf "$(pwd)/starship.toml" "$HOME/.config/starship.toml"

# mise
ln -sf "$(pwd)/mise/config.toml" "$HOME/.config/mise/config.toml"

# zed
ln -sf "$(pwd)/zed/settings.json" "$HOME/.config/zed/settings.json"

# vscode
ln -sf "$(pwd)/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
ln -sf "$(pwd)/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"

while read extension; do
    code --install-extension $extension --force
done < ./vscode/extensions.txt