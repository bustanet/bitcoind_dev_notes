#!/usr/bin/bash

tmux new-session -d -s 'bitcoin' 

tmux split-window -h 
tmux split-window -v
tmux split-window -v -t 0 


tmux send-keys -t 0 "printf '\033]2;%s\033\\' '~/.bitcoin/debug.log' && clear" C-m
tmux send-keys -t 0 'tail -f ~/.bitcoin/debug.log' C-m

tmux send-keys -t 2 "printf '\033]2;%s\033\\' 'journald -u bitcoind -f' && clear" C-m
tmux send-keys -t 2 'journalctl -u bitcoind -f' C-m
 
tmux send-keys -t 3 "printf '\033]2;%s\033\\' 'bitcoin-cli -getinfo' && clear" C-m
tmux send-keys -t 3 'watch bitcoin-cli -getinfo' C-m

tmux send-keys -t 1 "printf '\033]2;%s\033\\' 'Console' && clear" C-m
tmux -2 attach-session -t bitcoin
