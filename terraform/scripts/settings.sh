#!/bin/bash
set -e

sudo sed -i 's/PermitUserEnvironment no/PermitUserEnvironment yes/g' /etc/ssh/sshd_config
sudo bash -c 'echo "MaxSessions 1000" >> /etc/ssh/sshd_config'
sudo bash -c 'echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config'
sudo sed -i '/ClientAliveInterval/d' /etc/ssh/sshd_config
sudo sed -i '/ClientAliveCountMax/d' /etc/ssh/sshd_config
sudo sed -i 's/AcceptEnv .*/AcceptEnv \*/g' /etc/ssh/sshd_config
sudo service ssh restart

