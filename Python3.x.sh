
#______________________________________________________
# https://stackoverflow.com/questions/45542690/how-to-set-python3-5-2-as-default-python-version-on-centos/48757130#48757130
# https://web.archive.org/web/20200523111449/https://www.redhat.com/sysadmin/alternatives-command

sudo yum install -y python3
# Start by registering python2 as an alternative
alternatives --install /usr/bin/python python /usr/bin/python2 50

# Register python3.5 as an alternative
alternatives --install /usr/bin/python python /usr/bin/python3.6 60

# Select which Python version to use
alternatives --config python

# edit the file --> /usr/bin/yum and change to first line to --> "#!/usr/bin/python2"
# it's because yum does not support python3
#______________________________________________________
