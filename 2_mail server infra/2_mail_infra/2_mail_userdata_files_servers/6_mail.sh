#! /bin/bash
sudo hostnamectl set-hostname mail.hbgseries.in
sudo apt update
echo '127.0.1.1 mail.hbgseries.in' >> /etc/hosts
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
cd /opt
sudo git clone https://github.com/mailcow/mailcow-dockerized
# cd /opt/mailcow-dockerized
#./generate_config.sh -->fqdn:mail.hbgseries.in,enter,1
# nano mailcow.conf
# _db _user
# skip ipcheck_y
# skip httpver_y
# allow admin_email_login_y 
# #IPV6_NETWORK-->save
# docker compose pull
# docker compose up -d ---> save and open mail.hbgseries.in browser
# nano data/conf/nginx/redirect.conf
# server {
#   root /web;
#   listen 80 default_server;
#   listen [::]:80 default_server;
#   include /etc/nginx/conf.d/server_name.active;
#   if ( $request_uri ~* "%0A|%0D" ) { return 403; }
#   location ^~ /.well-known/acme-challenge/ {
#     allow all;
#     default_type "text/plain";
#   }
#   location / {
#     return 301 https://$host$uri$is_args$args;
#   }
# }
# docker compose restart --> ssl
# username:admin
# pass:moohoo
# email ---> config --> add domain-->domain: hbgseries.in ,selector:mcow ,tick all 3 relays options-->add domain and restart sogo
# click dns it will show dns records and those should be added in our host domain ( i think route53) and current state of a,ptr,mx,cname,srv,all txt records should get green tick
# to add mailbox-->mailbox-->add mailbox
# usernmae,fullname,password-->add
# to access our mailbox called sogo:-->apps-->webmail-->open in new tab or(mail.hbgseries.in/sogo/)  