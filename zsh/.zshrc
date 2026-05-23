lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

vd() {
    local target="$1"
    local args=("${@:2}")

    while [[ -v "aliases[$target]" ]]; do
        local expansion=(${(z)aliases[$target]})
        target="$expansion[1]"
        args=($expansion[2,-1] "${args[@]}")
    done

    local cmd="$target ${args[@]}"
    viddy --disable_mouse -d -n 1 --shell zsh "$cmd"
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
    gh
    golang
    jq
    kubectl
    kubectx
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
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char})

bindkey '§' fzf-history-widget
bindkey '§j' jq-complete
