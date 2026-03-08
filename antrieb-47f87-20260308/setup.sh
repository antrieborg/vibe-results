#!/bin/bash
# set -e removed by engine (prevents false failures)

export NEEDRESTART_MODE=a NEEDRESTART_SUSPEND=1 DEBIAN_FRONTEND=noninteractive

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 2; done

sudo apt-get install -y nginx

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw --force enable

systemctl is-enabled --quiet nginx || sudo systemctl enable nginx
systemctl is-active --quiet nginx || sudo systemctl start nginx

sudo systemctl is-active --quiet nginx && echo "nginx is running"
sudo ss -tlnp | grep :80
