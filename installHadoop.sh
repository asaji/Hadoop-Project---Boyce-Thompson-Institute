#!/bin/sh
#By Akhil A. Saji (asaji@bu.edu)
#This script attempts to automate as much of the base hadoop installation process as possible.
#Note 1:
#Line 10 of this script contains the PUBLIC RSA (id_rsa.pub) key used for SSH Authentication by the hduser:master node
#SSH Authentication by the master node is required for automatically spawning HDFS/MapReduce daemons'
#Note 2:
#Please keep a copy of the hadoop install tar.gz; if you recieve a wget error place the tar.gz file in your home directory and delete line 25.

#Configuration Variables
RSA_PUBLIC_KEY='AAAAB3NzaC1yc2EAAAADAQABAAABAQDI5tXt3FJZ8x+XezeSmSFiWJHCof1lR39SO8WKXufJD7rPXU1eK8FqWCwQM7ijGaCloEYLxbPXiY8r7HnU66huMTlDYH8ZAT6oxjY+VTv+55iRDB7R7RuQdnOmzpV6khUHxEXuhrPTBkAeno6xNa6IO0xX9tBL3GRqgh8LAk6Inwz64Jr9ACoKRBBrgM9R2cqbKSvzVaVn4cEi207cfkBJiPM+PqtqdzhLJRyXoVY7meNN/J0e7XQJ2uCx1FH7fpmPfi5ca+eQeNQrKX5WxSMZcyLCb7pXfdweffjC7sYGU+WfeJA3wNnjZO08vKysgOc1MITEz/WR0uXH/mKYMI2t hduser@shiv0'
HADOOP_INSTALL_PACKAGE=http://asaji.webfactional.com/file_stack/linuxRepo/hadoop-1.1.2.tar.gz
HOST_NAME=shiv2

#Create Groups/Users
echo Attempting to create hadoop user and group
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser

#Enable SSH Authentication for Master Node
cd ~
sudo cat > authorized_keys << EOF
ssh-rsa ${RSA_PUBLIC_KEY}
EOF
sudo mkdir /home/hduser/.ssh/
sudo mv authorized_keys /home/hduser/.ssh/
sudo chown hduser:hadoop /home/hduser/.ssh/authorized_keys
echo Copied hduser:master id_rsa.pub to authorized_keys

#Download/Install Hadoop
echo Downloading Hadoop...
cd ~
wget ${HADOOP_INSTALL_PACKAGE}
tar -xvf hadoop-1.1.2.tar.gz
sudo mv hadoop-1.1.2 /usr/local/hadoop
echo Hadoop Installed. Configuring...

#Configure Hadoop
  #Set Environment variables for hduser
cd /home/hduser
sudo bash -c "cat > .bashrc_temp << EOF
# Set Hadoop-related environment variables
export HADOOP_HOME=/usr/local/hadoop

# Set JAVA_HOME (we will also configure JAVA_HOME directly for Hadoop)
export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_25

# Add Hadoop bin/ directory to PATH
export PATH=$PATH:$HADOOP_HOME/bin
EOF"
sudo bash -c  "cat .bashrc_temp >> .bashrc"
sudo rm .bashrc_temp
echo PATH variables appended to /home/hduser/.bashrc

  #Configure conf/hadoop-env.sh
sudo sed -e "s:# export JAVA_HOME=/usr/lib/j2sdk1.5-sun:export JAVA_HOME=/usr/lib/jvm/jdk1.7.0_25:" /usr/local/hadoop/conf/hadoop-env.sh > /usr/local/hadoop/conf/hadoop-env.sh.new

if [ -e /usr/local/hadoop/conf/hadoop-env.sh.new ]; then
  rm /usr/local/hadoop/conf/hadoop-env.sh
fi
  mv /usr/local/hadoop/conf/hadoop-env.sh.new /usr/local/hadoop/conf/hadoop-env.sh
  
echo conf/hadoop-env.sh updated.

  #Configure /etc/hosts
sudo cp /etc/hosts /etc/hosts.old
sudo bash -c "sed -e 's:127.0.0.1\slocalhost:127.0.0.1  ${HOST_NAME}:;s:127.0.1.1\s${HOST_NAME}::' /etc/hosts.old > /etc/hosts"
echo /etc/hosts updated.

  #Create HDFS Directories
sudo mkdir -p /app/hadoop/tmp
sudo chown hduser:hadoop /app/hadoop/tmp
sudo chmod 750 /app/hadoop/tmp
