#!/bin/bash

# run with dot notatin i.e. . script to ensure that env variables are exported ok

env=~/.ssh/ssh-agent.env

declare -A keys
declare -A signatures
keys[git_key]=~/.ssh/id_ed25519
keys[gen_key]=~/.ssh/id_ecdsa
# signature from ssh-add -l output
signatures[git_key]="SHA256:25HhXa8OVPTosi6e1l0it35enkEPED+XT5xhgyX1A4E"
signatures[gen_key]="SHA256:Bq06BrdR/n7da8Olb/ItguhN9XX73PC3hEbOC8IAMzw"


agent_load_env() {
        test -f "$env" && . "$env" >| /dev/null ;
}

agent_start() {
        ssh-agent >| "$env"
        chmod 600 "$env"
        . "$env" >| /dev/null ;
}

addKeys() {
	for i in "${!keys[@]}"
	do
		read -p "Do you want to add key $i? (y/n) " yn
		case $yn in
			[Yy]* ) addkey ${keys[$i]} ${signatures[$i]};;
			[Nn]* ) continue;;
			* ) echo "Please answer yes or no.";;
		esac
	done

}

addkey() {
	if ssh-add -l | grep $2 > /dev/null; then
		echo "Key already added"
		return
	fi
	ssh-add $1
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)


if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
	agent_start
fi

addKeys "$@"

unset env
unset keys
unset signatures