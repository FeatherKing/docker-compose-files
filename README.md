# docker-compose-files

Collection of docker-compose files to start various services:
### Ingress
- traefik (LetsEncrypt certs are stored in a mapped volume but update from another process)

### Media
- plex
- radarr
- sonarr
- ombi
- tautulli
- sabnzbd

### Monitoring/Alerting:
- prometheus
- grafana
- alertmanager
- blackbox_exporter

### Misc:
- adguard (dns adblocking)
- frigate (open source NVR with object detection)
- wyze (docker-wyze-bridge for creating RTSP streams from wyze cameras)
- urbackup (cross platform backup tool)
- timemachine (macos time machine endpoint)

## Tools
- shaper.sh (restricts outgoing traffic speed to protect upload bandwidth)
- startup.sh (starts tmux sessions for docker compose files)
- tcshow (displays configured tc objects such as qdisc, class and filter)
- replace_secrets.sh (removes a supplied domain with 'replace.me')
