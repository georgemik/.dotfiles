alias ccat='grc -c /root/.grc/log4perl.grc cat'
alias ctail='grc -c /root/.grc/log4perl.grc tail'
alias cless='grc -c /root/.grc/log4perl.grc less -R'
alias cperl='grc -c /root/.grc/log4perl.grc perl'


# ssh connection to the lab machines
connect() {
        sudo sshpass -p 'Password1' ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $1
        if [ "$?" != 0 ]; then
                # change password routine, etc.
                sudo sshpass -p 'Password1' ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null $1
        fi
}

# start tmux session with two windows intialized
tmx() {
        session=jmik
        tmux new -s $session -d ; tmux rename-window -t $session ..root..;
        tmux new-window -t $session -n .:MAIN:.

        tmux select-window -t $session:.:MAIN:.
        tmux a -t $session
}

# fix perl locale issue
export LANG=en_US.utf8
export LC_ALL=C

# add new alias to switch home
alias h='cd ~'
