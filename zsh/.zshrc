vd() {
	local cmd=$(which $1)
	if [[ $cmd == "$1: aliased to"* ]]; then
		local aliased=$(echo "$cmd" | cut -d' ' -f 4-)
		viddy -d -n 1 --shell zsh "$aliased ${@:2}"
	else
		viddy -d -n 1 --shell zsh "$*"
	fi
}

alias home="cd $HOME"
alias src="cd $HOME/src"
alias github="cd $HOME/src/github.com"
alias dsprune="find . -name '*.DS_Store' -type f -delete"

alias cr="cursor"
alias d="docker"
alias g="git"
alias k="kubectl"
alias kc="kubectx"
alias kn="kubens"
alias mr="mise run"
alias oops="fuck"

plugins=(
    docker
    fzf
    git
    golang
    jq
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
bindkey '§j' jq-complete