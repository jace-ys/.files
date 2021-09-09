set -x

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# git
ln -sf "$(pwd)/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$(pwd)/git/.gitignore" "$HOME/.gitignore" \
    && git config --global core.excludesfile "$HOME/.gitignore"

brew install diff-so-fancy \
    && git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX" \
    && git config --global interactive.diffFilter "diff-so-fancy --patch"

brew install git-lfs

# vscode
brew install --cask visual-studio-code
brew tap homebrew/cask-fonts && brew install --cask font-jetbrains-mono
ln -sf "$(pwd)/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
ln -sf "$(pwd)/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"

while read extension; do
    code --install-extension $extension --force
done < ./vscode/extensions.txt

# zsh
ln -sf "$(pwd)/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$(pwd)/zsh/.zshenv" "$HOME/.zshenv"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# iterm2
brew install --cask iterm2

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -sf "$(pwd)/p10k/.p10k.zsh" "$HOME/.p10k.zsh"

# tools
brew install gotop ripgrep tmux tree

# misc
brew install --cask aerial