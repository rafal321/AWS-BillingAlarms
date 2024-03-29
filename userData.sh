#!/bin/bash

yum update -y
amazon-linux-extras install epel -y
yum install htop jq tmux stress -y
yum install httpd -y
service httpd start
chkconfig httpd on
NoPublicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
RAFIPPRIV=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
RAFAZ=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone/`
RAFDESC='Here goes your description'
RKTIME=$(date +%FT%T)

cd /var/www/html/
echo '<html><body style="background-color:GreenYellow">' > index.html
echo '<hr>' >> index.html
echo " -Timestamp: ${RKTIME} - Description: ${RAFDESC}" >> index.html
echo '<hr>' >> index.html
echo '<h2 style="color:darkblue;margin-left:50px;">' >> index.html
echo " - Public IP: ${NoPublicIP}" >> index.html
echo '</h2>' >> index.html
echo '<hr>' >> index.html
echo '<h2 style="color:Indigo;margin-left:50px;">' >> index.html
echo " - Private IP: ${RAFIPPRIV}" >> index.html
echo '</h2>' >> index.html
echo '<hr>' >> index.html
echo '<h2 style="color:DarkRed;margin-left:50px;">' >> index.html
echo " - AZ: ${RAFAZ}" >> index.html
echo '</h2>' >> index.html
echo '<hr>' >> index.html
echo '</html></body>' >> index.html

cd /home/ec2-user
echo '#!/bin/bash' > stressRaf.sh
echo 'stress --cpu  2 --timeout ${1}' >> stressRaf.sh
chmod +x stressRaf.sh

echo "set background=dark" > /home/ec2-user/.vimrc
echo "set tabstop=4" >> /home/ec2-user/.vimrc
echo "set shiftwidth=4" >> /home/ec2-user/.vimrc
echo "set expandtab" >> /home/ec2-user/.vimrc
echo "alias vi='vim'" >> /home/ec2-user/.bashrc
echo "set background=dark" >> /root/.vimrc
echo "alias vi='vim'" >> /root/.bashrc

# create swap
dd if=/dev/zero of=/swap count=4096 bs=1MiB &&
chmod 600 /swap &&
mkswap /swap &&
swapon /swap &&
echo "/swap swap swap sw 0 0" >> /etc/fstab

# Python3 & boto
yum install python3 -y
pip3 install --user boto3 pymysql
python3 -m pip install Faker # https://youtu.be/bW2uTvvqTg4

# Ansible
amazon-linux-extras install ansible2
yum install ansible

# Terraform - https://learn.hashicorp.com/tutorials/terraform/install-cli
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform
git clone https://github.com/hashivim/vim-terraform.git ~/.vim/pack/plugins/start/vim-terraform

# Docker - https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
