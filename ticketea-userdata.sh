#!/bin/bash
# sudo apt-get update -y
# sudo apt-get install -y docker.io
# sudo systemctl start docker
# sudo systemctl enable docker

# docker login -u ricardovasquezpe -p Ajinomoto123@
# docker pull ricardovasquezpe/ticketea:latest
# docker run -d -p 3000:3000 ricardovasquezpe/ticketea:latest

# curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose
# docker-compose --version

# git clone https://github.com/ricardovasquezpe/ticketea-infrastructure.git
# cd ticketea-infrastructure
# docker-compose up -d


sudo apt update
sudo apt upgrade -y

sudo apt install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Installed!"

sudo usermod -aG docker ubuntu
su -s ubuntu
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "Finished!"

echo "Start docker-compose!"

cd home/ubuntu
git clone https://github.com/ricardovasquezpe/ticketea-infrastructure.git
cd ticketea-infrastructure
docker login -u ricardovasquezpe -p password
docker-compose up -d

echo "Finish docker-compose!"