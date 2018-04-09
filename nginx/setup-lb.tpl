#!/bin/sh

cat > /etc/nginx/conf.d/default.conf <<EOF
log_format addHeaderlog '$remote_addr - $remote_user [$time_local] '
                '"$request" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" "$http_x_forwarded_for" "$request_body"';


access_log  /var/log/nginx/access.log  addHeaderlog;
error_log /var/log/nginx/error.log info;

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