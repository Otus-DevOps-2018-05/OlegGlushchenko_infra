#!/bin/bash
cd /usr/local/bin
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

echo -e "[Unit]\nDescription=Puma Rails Server\nAfter=network.target\n\n[Service]\nType=simple\nWorkingDirectory=/usr/local/bin/reddit\nExecStart=/usr/local/bin/puma\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/puma.service
systemctl daemon-reload
systemctl enable puma.service