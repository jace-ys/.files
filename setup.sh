#!/bin/bash

set -e

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo > "$HOME/.zprofile"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle

# git
ln -sf "$(pwd)/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$(pwd)/git/.gitignore" "$HOME/.gitignore"

# zsh
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/reegnz/jq-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/jq

mkdir -p "$HOME/.config"

# ghostty
mkdir -p "$HOME/.config/ghostty"
ln -sf "$(pwd)/ghostty/config" "$HOME/.config/ghostty/config"

# starship
ln -sf "$(pwd)/starship/config.toml" "$HOME/.config/starship.toml"

# mise
mkdir -p "$HOME/.config/mise"
ln -sf "$(pwd)/mise" "$HOME/.config/mise"

# cursor
ln -sf "$(pwd)/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
ln -sf "$(pwd)/cursor/keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"

while read extension; do
    code --install-extension $extension --force
done < ./vscode/extensions.txt

Echo "Setup complete! ✅"