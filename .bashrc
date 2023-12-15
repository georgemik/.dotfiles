
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

alias golint='golangci-lint run -v'

alias docker-compose='docker compose'
alias dc='docker compose'
complete -F _docker_compose dc
complete -F _docker_compose docker-compose

alias k=kubectl
complete -F __start_kubectl k

alias kctx='k config get-contexts'
alias kctxu='k config use-context'
alias kc='k config current-context'

alias linkWorkspace='/home/jmik/vcs/rand/workspaces/linkWorkspace.sh'
alias copyWorkspace='/home/jmik/vcs/rand/workspaces/copyWorkspace.sh'


# enable globstar (**)
shopt -s globstar

# enable ctrl+s for forward search during ctlr+r
stty -ixon


# user color promtp
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]($?) \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch) \n \$ '

# root color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]($?) \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch) \n \$ '

# snapshot bash history with each command (`shopt -s histappend` required)
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
