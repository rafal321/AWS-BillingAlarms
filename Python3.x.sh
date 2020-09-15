
#______________________________________________________
# Start by registering python2 as an alternative
alternatives --install /usr/bin/python python /usr/bin/python2 50

# Register python3.5 as an alternative
alternatives --install /usr/bin/python python /usr/bin/python3.5 60

# Select which Python version to use
alternatives --config python
#______________________________________________________
