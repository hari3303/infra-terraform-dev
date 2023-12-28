#! /bin/bash
sudo hostnamectl set-hostname sonarqube
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=65536
sudo apt-get install wget unzip -y
sudo apt update 
sudo apt install docker.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker $USER
touch ~/docker-compose.yml
echo 'version: "3"
services:
  sonarqube:
    container_name: sonarqube
    image: sonarqube:lts-community
    restart: always
    networks:
      - sonarnet
    depends_on:
      - db
    environment:
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=password123
      - SONARQUBE_JDBC_URL=jdbc:postgresql://db:5432/sonarqube
    ports:
      - "9000:9000"
    volumes:
      - sonarqube_conf:/opt/sonarqube/conf
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_bundled-plugins:/opt/sonarqube/lib/bundled-plugins
  db:
    image: postgres:12
    container_name: db
    restart: always
    ports:
      - 5432:5432
    networks:
      - sonarnet
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=password123
      - POSTGRES_DB=sonarqube
    volumes:
      - sonarqube_db:/var/lib/postgresql10
      - postgresql_data:/var/lib/postgresql10/data
volumes:
  postgresql_data:
  sonarqube_bundled-plugins:
  sonarqube_conf:
  sonarqube_data:
  sonarqube_db:
  sonarqube_extensions:
networks:
 sonarnet:
   name: sonarnet
   driver: bridge' >> ~/docker-compose.yml
sudo apt update
sudo apt install unzip
sudo wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
sudo unzip sonar-scanner-cli-4.8.0.2856-linux.zip
sudo mv sonar-scanner-4.8.0.2856-linux /opt/sonar-scanner
echo 'sonar.host.url=http://localhost:9000
sonar.sourceEncoding=UTF-8' >> /opt/sonar-scanner/conf/sonar-scanner.properties
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar -xvf node_exporter-0.18.1.linux-amd64.tar.gz
sudo mv node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
sudo useradd -rs /bin/false node_exporter
sudo tee /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list
sudo apt update
sudo apt install filebeat
sudo apt install net-tools
sudo apt update
sudo apt install nginx -y
echo 'server {
    listen 80;
    server_name sonarqube.hbgseries.in;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name sonarqube.hbgseries.in;

    #ssl_certificate /root/sonarqube.hbgseries.in.crt;
    #ssl_certificate_key /root/sonarqube.hbgseries.in.key;

    location / {
        proxy_pass http://localhost:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
} ' > /etc/nginx/sites-available/default
sudo systemctl restart nginx
# sudo snap install core; sudo snap refresh core
# sudo snap install --classic certbot
# sudo ln -s /snap/bin/certbot /usr/bin/certbot
# sudo systemctl restart nginx
# sudo certbot --nginx -d sonarqube.hbgseries.in --agree-tos --email hbseries.shop@gmail.com