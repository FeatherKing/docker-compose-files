#!/bin/bash

tmux new-session -d -s docker
tmux new-session -d -s monitoring

# this statement is a life-saver for tmux detached sessions
tmux set-option -t docker set-remain-on-exit on
tmux set-option -t monitoring set-remain-on-exit on

# In my case running the script in a new window worked
tmux new-window -d -n 'nameofWindow' -t docker:1 'docker-compose -f /home/media/nzb.compose up'
tmux new-window -d -n 'nameofWindow' -t monitoring:1 'docker-compose -f /home/media/monitoring.compose up'

exit 0
