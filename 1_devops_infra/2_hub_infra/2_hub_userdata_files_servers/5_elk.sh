#! /bin/bash
sudo hostnamectl set-hostname elk
sudo apt update
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch
sudo sed -i -e 's/.*#network.host: 192.168.0.1.*/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml 
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo apt install kibana
sudo systemctl enable kibana
sudo systemctl start kibana
sudo apt install logstash
echo 'input {
  beats {
    port => 5044
  }
} ' > /etc/logstash/conf.d/02-beats-input.conf
echo 'output {
  if [@metadata][pipeline] {
	elasticsearch {
  	hosts => ["localhost:9200"]
  	manage_template => false
  	index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  	pipeline => "%{[@metadata][pipeline]}"
	}
  } else {
	elasticsearch {
  	hosts => ["localhost:9200"]
  	manage_template => false
  	index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
	}
  }
} ' > /etc/logstash/conf.d/30-elasticsearch-output.conf
sudo systemctl start logstash
sudo systemctl enable logstash
sudo apt install filebeat
sudo sed -i -e 's/.*output.elasticsearch:.*/#output.elasticsearch:/' /etc/filebeat/filebeat.yml
sudo sed -i -e 's/.*hosts: \["localhost:9200"\].*/#hosts: \["localhost:9200"\]/' /etc/filebeat/filebeat.yml
sudo sed -i -e 's/.*#output.logstash:.*/output.logstash:/' /etc/filebeat/filebeat.yml
sudo sed -i -e 's/^\(\s*#\)\?\(\s*hosts: \["localhost:5044"\]\)/  \2/' /etc/filebeat/filebeat.yml
sudo filebeat modules enable system
sudo filebeat setup --pipelines --modules system
sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'
sudo filebeat setup -E output.logstash.enabled=false -E output.elasticsearch.hosts=['localhost:9200'] -E setup.kibana.host=localhost:5601
sudo systemctl start filebeat
sudo systemctl enable filebeat
sudo apt update
sudo apt install nginx -y
echo 'server {
    listen 80;
    server_name kibana.hbgseries.in;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name kibana.hbgseries.in;

    ssl_certificate /root/kibana.hbgseries.in.crt;
    ssl_certificate_key /root/kibana.hbgseries.in.key;

    location / {
        proxy_pass http://localhost:5601;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}' > /etc/nginx/sites-available/default
sudo systemctl restart nginx
# # sudo snap install core; sudo snap refresh core
# # sudo snap install --classic certbot
# # sudo ln -s /snap/bin/certbot /usr/bin/certbot
# # sudo systemctl restart nginx
# # sudo certbot --nginx -d elk.hbgseries.in --agree-tos --email hbseries.shop@gmail.com
