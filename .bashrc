
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

# fix perl locale issue
export LANG=en_US.utf8
export LC_ALL=C

alias tmux='tmux -u'
alias diff='colordiff'
alias grep='grep --color=always'

# enable globstar (**)
shopt -s globstar

# enable ctrl+s for forward search during ctlr+r
stty -ixon


# user color promtp
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]($?) \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch) \n \$ '

# root color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;36m\]($?) \u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch) \n \$ '

# snapshot bash history with each command (`shopt -s histappend` required)
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
