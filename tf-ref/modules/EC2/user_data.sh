#!/bin/bash
REGION="us-east-1"
sudo yum update -y
## install docker
sudo amazon-linux-extras install -y docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# ## start service
sudo systemctl enable docker
## install codedeploy
sudo yum -y install ruby
sudo yum -y install wget
cd /home/ec2-user
wget https://aws-codedeploy-$REGION.s3.$REGION.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
## start codedeploy agent. Must end of all
sudo service codedeploy-agent start