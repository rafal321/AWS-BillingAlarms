#!/bin/bash

yum update -y
yum install htop -y
yum install httpd -y
service httpd start
chkconfig httpd on
NoPublicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
RAFIPPRIV=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
RAFAZ=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone/`
RAFDESC='Here goes your description'

cd /var/www/html/
echo '<html><body style="background-color:GreenYellow">' > index.html
echo '<hr>' >> index.html
echo " - Description: ${RAFDESC}" >> index.html
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
amazon-linux-extras install epel -y
yum install stress -y

echo '#!/bin/bash' > stressRaf.sh
echo 'stress --cpu  2 --timeout ${1}' >> stressRaf.sh
chmod +x stressRaf.sh

echo "set background=dark" > /home/ec2-user/.vimrc
echo "set tabstop=4" >> /home/ec2-user/.vimrc
echo "set shiftwidth=4" >> /home/ec2-user/.vimrc
echo "set expandtab" >> /home/ec2-user/.vimrc
echo "set background=dark" >> /home/ec2-user/.vimrc
