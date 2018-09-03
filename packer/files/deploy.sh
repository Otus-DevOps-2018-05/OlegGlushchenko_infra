#!/bin/bash
cd /usr/local/bin
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

cat <<EOF > /etc/systemd/system/puma.service
[Unit]
Description=Puma Rails Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/bin/reddit
ExecStart=/usr/local/bin/puma
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable puma.service