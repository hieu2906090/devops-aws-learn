#!bin/bash

# ------------------------------------------------------------- 
# I. SET UP NGINX AND CONFIG
# S1. Install nginx
# su -l ubuntu
# sudo -i 
sudo apt update
sudo apt install -y nginx

# S2. Set nginx as a service (for rebooting system) -> nginx default setup set as service so not rq to do this step
# 1.
# ref: https://www.nginx.com/resources/wiki/start/topics/examples/systemd/

sudo printf "[Unit]
        \nDescription=The NGINX HTTP and reverse proxy server
        \nAfter=syslog.target network-online.target remote-fs.target nss-lookup.target
        \nWants=network-online.target
        \n
        \n[Service]
        \nType=forking
        \nPIDFile=/var/run/nginx.pid
        \nExecStartPre=/usr/sbin/nginx -t
        \nExecStart=/usr/sbin/nginx
        \nExecReload=/usr/sbin/nginx -s reload
        \nExecStop=/sbin/kill -s QUIT \$MAINPID
        \nPrivateTmp=true
        \n
        \n[Install]
        \nWantedBy=multi-user.target" >> /lib/systemd/system/nginx.service
        
sudo chmod 400 /lib/systemd/system/nginx.service

# 2. Enable & Start nginx service
sudo systemctl enable nginx

# ------------------------------------------------------------- 
# II. Config nginx to serve static html on specific location
# cd /etc/nginx/
sudo rm /etc/nginx/nginx.conf
sudo touch /etc/nginx/nginx.conf

sudo printf "events {
        \n}
        \nhttp {
        \n  types {
        \n      text/html html;
        \n      text/css css;
        \n  }
        \n  server {
        \n      listen 80;
        \n      root /var/www/html;
        \n      index index.html index.htm;
        \n    }
        \n}
        " >> /etc/nginx/nginx.conf

sudo systemctl start nginx

# ------------------------------------------------------------- 
# III. Download vnexpress and save to folder
sudo mkdir /var/www
sudo curl https://vnexpress.net -o /var/www/html/index.html