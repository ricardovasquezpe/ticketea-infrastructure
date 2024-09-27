#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

docker login -u ricardovasquezpe -p Ajinomoto123@
# docker pull ricardovasquezpe/ticketea:latest
# docker run -d -p 3000:3000 ricardovasquezpe/ticketea:latest

curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# docker-compose --version
