#!/bin/bash
# set -e removed by engine (prevents false failures)

export NEEDRESTART_MODE=a NEEDRESTART_SUSPEND=1 DEBIAN_FRONTEND=noninteractive

while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do sleep 2; done

sudo apt-get install -y curl wget build-essential python3 python3-dev nginx

export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  mkdir -p "$NVM_DIR"
  curl -sL https://github.com/nvm-sh/nvm/archive/refs/tags/v0.40.1.tar.gz | tar -xz -C "$NVM_DIR" --strip-components=1
fi
source "$NVM_DIR/nvm.sh"
nvm install 20

npm install -g n8n pm2

mkdir -p ~/.n8n

sudo tee /etc/systemd/system/n8n.service > /dev/null <<'EOF'
[Unit]
Description=n8n Workflow Automation
After=network.target

[Service]
Type=simple
User=antrieb
WorkingDirectory=/home/antrieb
Environment="PATH=/home/antrieb/.nvm/versions/node/v20.11.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Environment="HOME=/home/antrieb"
ExecStart=/home/antrieb/.nvm/versions/node/v20.11.1/bin/n8n start
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start n8n
systemctl is-enabled --quiet n8n || sudo systemctl enable n8n

sleep 5

sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5678;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_buffering off;
    }
}
EOF

sudo nginx -t

sudo systemctl restart nginx
systemctl is-enabled --quiet nginx || sudo systemctl enable nginx

sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw --force enable

echo "n8n workflow automation installed and configured"
sudo systemctl is-active --quiet n8n && echo "n8n is running"
sudo systemctl is-active --quiet nginx && echo "nginx is running"
sudo ss -tlnp | grep -E ':(80|5678)'
