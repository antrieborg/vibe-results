#!/bin/bash

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm nginx

sudo tee /etc/nginx/nginx.conf > /dev/null <<'EOF'
user http;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        server_name _;

        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
        }
    }
}
EOF

sudo nginx -t

sudo systemctl restart nginx
systemctl is-enabled --quiet nginx || sudo systemctl enable nginx

sudo ss -tlnp | grep :80

echo "nginx installed and configured"
sudo systemctl is-active --quiet nginx && echo "nginx is running"
