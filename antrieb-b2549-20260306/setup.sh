#!/bin/bash

export NEEDRESTART_MODE=a NEEDRESTART_SUSPEND=1 DEBIAN_FRONTEND=noninteractive

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 2; done

sudo apt-get install -y nginx

sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
}
EOF

sudo nginx -t

sudo systemctl restart nginx
systemctl is-enabled --quiet nginx || sudo systemctl enable nginx

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw --force enable

echo "nginx reverse proxy configured for port 3000"
sudo systemctl is-active --quiet nginx && echo "nginx is running"
sudo ss -tlnp | grep :80
