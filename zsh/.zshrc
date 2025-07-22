vd() {
	local cmd=$(which $1)
	if [[ $cmd == "$1: aliased to"* ]]; then
		local aliased=$(echo "$cmd" | cut -d' ' -f 4-)
		viddy -d -n 1 --shell zsh "$aliased ${@:2}"
	else
		viddy -d -n 1 --shell zsh "$*"
	fi
}

secret-dyff-pr () {
	local LIGHT_CYAN="\033[1;36m"
	local RED="\033[1;31m"
	local GREEN="\033[1;32m"
	local YELLOW="\033[1;33m"
	local NOCOLOR="\033[0m"
	local pullRequestId=$1
	if [ -z $pullRequestId ]
	then
		echo "${RED}Provide a PR as an argument, e.g. secret-dyff-pr 12345${NOCOLOR}"
		return 1
	fi
	local headRefName=$(gh pr view $pullRequestId --json headRefName --jq '.headRefName')
	local temp_dir_root=$(mktemp -d)
	local files=$(gh pr view $pullRequestId --json files --jq '.files[].path | select(. | contains("secrets"))')
	local numOfFiles=$(echo $files | wc -l | tr -d ' ')
	local count=0
	local currentBranch=$(git rev-parse --abbrev-ref HEAD)
	git pull --all
	git checkout $headRefName
	git pull
	echo "\nThere are $numOfFiles secrets changed in this PR"
	echo $files | while read file
	do
		(( count++ ))
		local temp_dir=$temp_dir_root/$(dirname $file)
		mkdir -p $temp_dir
		local temp_before=$temp_dir/$(basename $file)_before
		local temp_after=$temp_dir/$(basename $file)_after
		git show master:$file | sops --input-type yaml --output-type yaml -d /dev/stdin > $temp_before
		git show $headRefName:$file | sops --input-type yaml --output-type yaml -d /dev/stdin > $temp_after
		local temp_before_hash=$(shasum $temp_before | cut -d ' ' -f1)
		local temp_after_hash=$(shasum $temp_after | cut -d ' ' -f1)
		if [[ $temp_before_hash == $temp_after_hash ]]
		then
			echo "\n${YELLOW}No diff found between master:$file and $headRefName:$file${NOCOLOR}"
		else
			echo "\n\n${LIGHT_CYAN}Reviewing $file${NOCOLOR}"
			dyff between $temp_before $temp_after
			if [[ $count != $numOfFiles ]]
			then
				while true
				do
					echo "\nPress space for next file"
					read -sk
					case $REPLY in
						(\ ) break ;;
						(*)  ;;
					esac
				done
			fi
		fi
		rm $temp_before $temp_after
	done
	echo "\n\n${GREEN}All files reviewed${NOCOLOR}"
	rm -rf $temp_dir_root
	git checkout $currentBranch
}

get-redis-on-node () {
	local node=$1
	if [ -z "$node" ]
	then
		echo "ERR: node not provided, usage:"
		echo "  get-redis-on-node NODE_NAME"
		return 1
	fi
	for pod in $(kubectl get pods --no-headers -o custom-columns=":metadata.name"  --field-selector spec.nodeName="$node" -l redis-component!=sentinel)
	do
		role=$(kubectl exec -i "$pod" -c redis -- sh -c 'redis-cli --no-auth-warning -a $AUTH role | grep -E "(master|slave)"')
		echo "$pod - $role"
	done
}

get-k8s-nodes() {
    kubectl get nodes -o custom-columns="NAME:metadata.name,STATUS:status.conditions[-1].type,IP_ADDRESS:status.addresses[?(@.type == 'InternalIP')].address,ZONE:metadata.labels.topology\.kubernetes\.io/zone,INSTANCE_TYPE:metadata.labels.node\.kubernetes\.io/instance-type,CREATED:metadata.creationTimestamp" $@
}

get-pods-on-node() {
    local node=$1
    kubectl get pods -o wide --field-selector spec.nodeName=$node
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
    terraform
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