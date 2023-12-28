#! /bin/bash
sudo hostnamectl set-hostname k8s
sudo apt update
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
sudo mv kops-linux-amd64 kops
chmod +x kops
sudo mv kops /usr/local/bin/kops
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
aws s3 rb s3://nonprodhbgseries.in
aws s3 mb s3://nonprodhbgseries.in
echo "export NAME=hbgseries.in" >> ~/.bashrc
echo "export KOPS_STATE_STORE=s3://nonprodhbgseries.in" >> ~/.bashrc
echo "export EDITOR=nano" >> ~/.bashrc
source .bashrc
touch ~/createcluster.sh
echo "kops create cluster --name=hbgseries.in --state=s3://nonprodhbgseries.in --zones=us-east-1b --networking calico --node-count=2 --master-size=t2.large --master-volume-size 20  --node-size=t2.large --node-volume-size 20 --dns private --topology private" >> ~/createcluster.sh
touch ~/kopssecretssh.sh
echo "kops create secret --name hbgseries.in --state=s3://nonprodhbgseries.in sshpublickey admin -i ~/.ssh/id_rsa.pub" >> ~/kopssecretssh.sh
touch ~/updatecluster.sh
echo "kops update cluster --name hbgseries.in --yes --admin" >> ~/updatecluster.sh
touch ~/deletecluster.sh
echo "kops delete cluster --name=hbgseries.in --state=s3://nonprodhbgseries.in --yes" >> ~/deletecluster.sh
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
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