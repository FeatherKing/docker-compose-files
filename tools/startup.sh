#!/bin/bash
## Usage: startup.sh
##
## Purpose: start various docker-compose files and keep log output in tmux
##          this allows quick switching between related windows
##

tmux new-session -d -s docker-compose

# this statement is a life-saver for tmux detached sessions
tmux set-option -t docker-compose remain-on-exit on

# Running the script in a new window starts process in tmux
tmux new-window -d -n 'traefik' -t docker-compose:1 '/usr/bin/docker compose -f /home/media/traefik.compose up'
tmux new-window -d -n 'media' -t docker-compose:2 '/usr/bin/docker compose -f /home/media/nzb.compose up'
tmux new-window -d -n 'monitoring' -t docker-compose:3 '/usr/bin/docker compose -f /home/media/monitoring.compose up'
#tmux new-window -d -n 'unifi' -t docker-compose:4 '/usr/bin/docker compose -f /home/media/unifi.compose up'
tmux new-window -d -n 'urbackup' -t docker-compose:5 '/usr/bin/docker compose -f /home/media/urbackup.compose up'
tmux new-window -d -n 'timemachine' -t docker-compose:6 '/usr/bin/docker compose -f /home/media/timemachine.compose up'
tmux new-window -d -n 'wyze' -t docker-compose:7 '/usr/bin/docker compose -f /home/media/wyze.compose up'
tmux new-window -d -n 'frigate' -t docker-compose:8 '/usr/bin/docker compose -f /home/media/frigate.compose up'
tmux new-window -d -n 'adguard' -t docker-compose:9 '/usr/bin/docker compose -f /home/media/adguard.compose up'

exit 0
