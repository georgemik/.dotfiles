#!/bin/bash

# run with dot notatin i.e. . script to ensure that env variables are exported ok

env=~/.ssh/ssh-agent.env
key=/home/jmik/.ssh/id_ed25519_bblnx

agent_load_env() {
        test -f "$env" && . "$env" >| /dev/null ;
}

agent_start() {
        ssh-agent >| "$env"
        chmod 600 "$env"
        . "$env" >| /dev/null ;
}

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
        agent_start
        ssh-add $key
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
        ssh-add $key
fi

unset env
