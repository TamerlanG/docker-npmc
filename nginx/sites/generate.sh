#!/bin/sh

SERVER_NAME=$1
FILE_PATH=$(dirname "$0")/$SERVER_NAME.conf

cat > $FILE_PATH << EOF
server {
    
    #listen 80 default_server;
    listen 80;
    #listen [::]:80 default_server ipv6only=on;
    
    server_name $SERVER_NAME.test;
    root /var/www/$SERVER_NAME/web;
    index index.php index.html index.htm;
    
    location / {
         try_files \$uri $uri/ /index.php\$is_args\$args;
    }
    
    location ~ \\.php\$ {
        try_files \$uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        #fixes timeouts
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }
    
    location ~ /\\.ht {
        deny all;
    }
    
    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }
}
EOF