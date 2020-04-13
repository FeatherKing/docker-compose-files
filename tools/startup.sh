#!/bin/bash
## Usage: startup.sh
##
## Purpose: start various docker-compose files and keep log output in tmux
##          this allows quick switching between related windows
##

tmux new-session -d -s docker-compose

# this statement is a life-saver for tmux detached sessions
tmux set-option -t docker-compose set-remain-on-exit on

# Running the script in a new window starts process in tmux
tmux new-window -d -n 'media' -t docker-compose:1 'docker-compose -f /home/media/nzb.compose up'
tmux new-window -d -n 'monitoring' -t docker-compose:2 'docker-compose -f /home/media/monitoring.compose up'
tmux new-window -d -n 'unifi' -t docker-compose:3 'docker-compose -f /home/media/unifi.compose up'
tmux new-window -d -n 'urbackup' -t docker-compose:4 'docker-compose -f /home/media/urbackup.compose up'
tmux new-window -d -n 'timemachine' -t docker-compose:5 'docker-compose -f /home/media/timemachine.compose up'

exit 0
