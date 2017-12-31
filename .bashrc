alias ccat='grc -c /root/.grc/log4perl.grc cat'
alias ctail='grc -c /root/.grc/log4perl.grc tail'
alias cless='grc -c /root/.grc/log4perl.grc less -R'
alias cperl='grc -c /root/.grc/log4perl.grc perl'

# ssh connection to the lab machines
connect() {
	ssh-keygen -f "/root/.ssh/known_hosts" -R $1
	sshpass -p 'Password1' ssh -oStrictHostKeyChecking=no $1
}

tmx() {
	tmux new -s w -d ; tmux rename-window -t w .:MAIN:.; tmux a -t w
}
