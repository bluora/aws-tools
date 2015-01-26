#!/bin/sh

if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get install git unzip wget curl gawk
else
	sudo yum install git unzip wget curl -y
fi

cd /usr/local/src/ && sudo curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && sudo unzip awscli-bundle.zip && sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws
cd /usr/local/src/ && sudo wget -q http://s3.amazonaws.com/ec2metadata/ec2-metadata && sudo chmod +x ec2-metadata && sudo mv ec2-metadata /usr/bin

sudo ln -s /usr/local/aws-tools/bin/aws-get-instances /usr/bin/aws-get-instances
sudo ln -s /usr/local/aws-tools/bin/aws-run-remote-command /usr/bin/aws-run-remote-command
sudo ln -s /usr/local/aws-tools/bin/aws-update-route53-public-ip /usr/bin/aws-update-route53-public-ip

sudo cp /usr/local/aws-tools/service/aws-update-route53.example.cfg /etc/aws-update-route53.cfg
