#!/bin/sh

cat > /etc/nginx/conf.d/default.conf <<EOF

server {
  listen 80;
  status_zone backend;
  root /usr/share/nginx/html;
  location / {
  }

  location = /status.html {
  }
  location /status {
    access_log off;
    status;
  }
}
EOF

nginx -s reload