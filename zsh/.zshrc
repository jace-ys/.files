alias home="cd $HOME"
alias src="cd $HOME/src"
alias github="cd $HOME/src/github.com"
alias dsprune="find . -name '*.DS_Store' -type f -delete"

alias d="docker"
alias g="git"
alias k="kubectl"
alias kc="kubectx"
alias kn="kubens"
alias oops="fuck"

plugins=(
    docker
    fzf
    git
    golang
    kubectl
    mise
    opentofu
    starship
    thefuck
    tldr
    tmux
    zoxide
)

export ZSH="$HOME/.oh-my-zsh"
export PATH="/opt/homebrew/bin:$HOME/go/bin:$PATH"
source $ZSH/oh-my-zsh.sh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[$ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(i)forward-char]]=()

bindkey '§' fzf-history-widget