#!/bin/bash
sudo apt update
sudo apt upgrade -y

sudo apt install -y curl unzip
sudo apt-get install -y jq

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws sts get-caller-identity

#sudo apt install -y ca-certificates curl gnupg lsb-release

#sudo mkdir -p /etc/apt/keyrings
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#sudo echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt update

#sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

#echo "Installed!"

#sudo usermod -aG docker ubuntu
#su -s ubuntu
#sudo chmod 666 /var/run/docker.sock
#sudo systemctl restart docker

#curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose
#docker-compose --version

#echo "Finished!"

#echo "Start docker-compose!"

cd home/ubuntu
git clone https://github.com/ricardovasquezpe/ticketea-infrastructure.git
cd ticketea-infrastructure/resources
#docker login -u ricardovasquezpe -p Ajinomoto123@

SECRET_NAME="ticketea-secrets"
SECRET_JSON=$(aws secretsmanager get-secret-value \
    --secret-id $SECRET_NAME \
    --query 'SecretString' \
    --output text)

PUBLICIP=$(echo $SECRET_JSON | jq -r '.publicIp')
BUCKETNAME=$(echo $SECRET_JSON | jq -r '.bucketName')
ACCESSKEY=$(echo $SECRET_JSON | jq -r '.accessKey')
ACCESSSECRET=$(echo $SECRET_JSON | jq -r '.accessSecret')
REGION=$(echo $SECRET_JSON | jq -r '.region')

sudo su
echo "AWS_S3_BUCKET_NAME=$BUCKETNAME" >> .env.backend
echo "AWS_ACCESS_KEY=$ACCESSKEY" >> .env.backend
echo "AWS_ACCESS_SECRET=$ACCESSSECRET" >> .env.backend
echo "AWS_S3_REGION=$REGION" >> .env.backend

echo "VITE_API_URL=$PUBLICIP" >> .env.frontend
exit
#docker-compose up -d

#echo "Finish docker-compose!"