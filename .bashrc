
# ssh connection to the lab machines
connect() {
        sudo sshpass -p 'Password1' ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $1
        if [ "$?" != 0 ]; then
                # change password routine, etc.
                sudo sshpass -p 'Password1' ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $1
        fi
}

transfer() {
        sshpass -p 'Password1' scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $@
}

# start tmux session with two windows intialized
tmx() {
        session=jmik
        tmux new -s $session -d ; tmux rename-window -t $session ..root..;
        tmux new-window -t $session -n ..main..

        tmux select-window -t $session:..main..
        tmux a -t $session
}

git_branch() {
	if ! git rev-parse --git-dir &>/dev/null; then
		return 0
	fi
 
	local git_current_branch="$(git branch 2>/dev/null | grep -oP '(?<=^\*\s).*')"
	echo " (${git_current_branch})"
}

kubectl_ctx() {
    local current_context="$(grep -Po "(?<=current-context: ).*" --color=never ~/.kube/config 2>/dev/null)"
    echo " ${current_context}"
}

alias tmux='tmux -u'
alias diff='colordiff'
alias grep='grep --color=always'
alias gotest='bash /home/jmik/vcs/rand/scripts/gotest.sh'
alias jp='bash -c /c/vcs/rand/scripts/json-pretty/jp'
alias urlencode='bash -c /home/jmik/vcs/rand/scripts/urlencode/urlencode'
alias myuuidgen='f(){ bash -c "/home/jmik/vcs/rand/scripts/uuidgen/uuidgen \"$@\"";  unset -f f; }; f'
alias ip='ip -c'
alias fix-net='sudo ip link set dev eth0 mtu 1350'

kdiff() {
    if [ $# -lt 2 ]; then
        echo "Usage: kdiff <context_id> <deployment-path> [additional-kubectl-args...]"
        echo "Example: kdiff eu-01 deployments/iocmq"
	echo "kubectl --context=CTX diff -k deployments/DEPL/deployment_id/CTX | colordiff"
        return 1
    fi
    
    local context_id=$1
    local deployment_path=$2
    shift 2  # Remove first two arguments

    kubectl --context="$context_id" diff -k "${deployment_path}/deployment_id/${context_id}" "$@" | colordiff
}

jump() {
    if [ $# -lt 1 ]; then
        echo "SSH via jump server to root"
        echo ""
        echo "Usage: jump <host ip address>"
        echo "Example: scp-jump 1.2.3.5"
        return 1
    fi

    ssh -J jump-server root@"$@"
}

scp-jump() {
    if [ $# -lt 2 ]; then
        echo "SCP copy via jump server (to/from)"
        echo ""
        echo "Usage: scp-jump <user@host ip address>:<host path> <local path>"
        echo "Example: scp-jump root@1.2.3.5:/tmp/domains.csv /tmp/"
        return 1
    fi

    scp -oProxyCommand="ssh -q -W %h:%p jump-server" "$@"
}


alias golint='golangci-lint run -v'

alias docker-compose='docker compose'
complete -F _docker_compose dc
complete -F _docker_compose docker-compose

alias k=kubectl
complete -F __start_kubectl k
complete -F __start_kubectl kstg
complete -F __start_kubectl kcen

alias kctx='k config get-contexts'
alias kctxu='k config use-context'

alias linkWorkspace='/home/jmik/vcs/rand/workspaces/linkWorkspace.sh'
alias copyWorkspace='/home/jmik/vcs/rand/workspaces/copyWorkspace.sh'
alias delim='echo -e "\n\033[43;97m=== $(date "+%Y-%m-%d %H:%M:%S.%3N") $(printf "%-120s" | tr " " "=") ===\033[0m\n"'

# enable globstar (**)
shopt -s globstar

# enable ctrl+s for forward search during ctlr+r
stty -ixon

# snapshot bash history with each command
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"