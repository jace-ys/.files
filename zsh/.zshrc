alias home="cd $HOME"
alias dsprune="find . -name '*.DS_Store' -type f -delete"

alias d="docker"
alias g="git"
alias k="kubectl"

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[$ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(i)forward-char]]=()

eval "$(/opt/homebrew/bin/mise activate zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

bindkey '§' fzf-history-widget