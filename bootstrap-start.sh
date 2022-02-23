#!/bin/bash
#turn off go mudules
cd ~
git clone https://github.com/g-lz-automation/lz-frontend-backend.git
cd ~/lz-frontend-backend/backend

if [ -z "$GO111MODULE" ]; then
echo "Setting env variable for go"
echo "export GO111MODULE=off" >> $HOME/.profile
source $HOME/.profile
fi
#Install go packages
cd ~/lz-frontend-backend/backend
go get "github.com/google/go-github/github"
go get "golang.org/x/oauth2"
go build

#Run Go server
cd ~/lz-frontend-backend && backend/backend &

cd ~/

#Install Docker
#sudo curl -fsSL https://get.docker.io | sh 
sudo docker pull jenkins/jenkins:lts
sudo docker build -t jenkins:custom -f /tmp/jenkins/Dockerfile ~/lz-bootstrap/jenkins/

sudo mv ~/lz-bootstrap/jenkins/start-jenkins.sh /bin/
sudo mv ~/lz-bootstrap/jenkins/stop-jenkins.sh /bin/
sudo mv ~/lz-bootstrap/jenkins/jenkins.service /etc/systemd/system/
sudo chmod 640 /etc/systemd/system/jenkins.service
sudo chmod +x /bin/start-jenkins.sh
sudo chmod +x /bin/stop-jenkins.sh
sudo systemctl enable jenkins

#Adding bootstrap to group docker
sudo usermod -a -G docker bootstrap