#!/bin/sh
#By Akhil A. Saji (asaji@bu.edu) for Boyce Thompson Institute @ Cornell University
#This script attempts to automate as much of the worker node hadoop installation process as possible.


#################################################################################
#Configuration Variables - Please Read Through This Section Before Running Script
#################################################################################

MASTER_NODE_NAME=shiv0
#id_rsa.pub key for hduser@master; this is required because the master node activates slave daemons via SSH
RSA_PUBLIC_KEY='AAAAB3NzaC1yc2EAAAADAQABAAABAQDI5tXt3FJZ8x+XezeSmSFiWJHCof1lR39SO8WKXufJD7rPXU1eK8FqWCwQM7ijGaCloEYLxbPXiY8r7HnU66huMTlDYH8ZAT6oxjY+VTv+55iRDB7R7RuQdnOmzpV6khUHxEXuhrPTBkAeno6xNa6IO0xX9tBL3GRqgh8LAk6Inwz64Jr9ACoKRBBrgM9R2cqbKSvzVaVn4cEi207cfkBJiPM+PqtqdzhLJRyXoVY7meNN/J0e7XQJ2uCx1FH7fpmPfi5ca+eQeNQrKX5WxSMZcyLCb7pXfdweffjC7sYGU+WfeJA3wNnjZO08vKysgOc1MITEz/WR0uXH/mKYMI2t hduser@shiv0'
#Location of the tar.gz for the hadoop package. Script has only been tested on 1.1.2- use other versions at your own discretion.
HADOOP_INSTALL_PACKAGE=http://asaji.webfactional.com/file_stack/linuxRepo/hadoop-1.1.2.tar.gz
#Host name of the worker node this script is being run on. MUST be the same name as in master:conf/slaves file
HOST_NAME=shiv2
#Number of replicates HDFS should make from each block stored in the cluster. Default is 1; (Do not exceed greater than worker node count)
DFS_REPLICATION_COUNT=1
#Path for JDK7 Installation
JAVA_PATH=/usr/lib/jvm/jdk1.7.0_25

#################################################################################
#Do Not Edit Below This Line (Unless you know what you're doing)
#################################################################################

#Create Groups/Users
echo "Attempting to create hadoop user and group..."
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
echo "Copied hduser:master id_rsa.pub to authorized_keys"

#Download/Install Hadoop
echo "Downloading Hadoop..."
cd ~
wget ${HADOOP_INSTALL_PACKAGE}
tar -xvf hadoop-1.1.2.tar.gz
sudo mv hadoop-1.1.2 /usr/local/hadoop
echo "Hadoop Successfully Installed. Configuring..."

#Configure Hadoop
  #Set Environment variables for hduser
cd /home/hduser
sudo bash -c "cat > .bashrc_temp << EOF
# Set Hadoop-related environment variables
export HADOOP_HOME=/usr/local/hadoop

# Set JAVA_HOME (we will also configure JAVA_HOME directly for Hadoop)
export JAVA_HOME=${JAVA_PATH}

# Add Hadoop bin/ directory to PATH
export PATH=$PATH:$HADOOP_HOME/bin
EOF"
sudo bash -c  "cat .bashrc_temp >> .bashrc"
sudo rm .bashrc_temp
echo "PATH variables appended to /home/hduser/.bashrc"

  #Configure /usr/local/hadoop/conf/hadoop-env.sh
sudo cp /usr/local/hadoop/conf/hadoop-env.sh /usr/local/hadoop/conf/hadoop-env.sh.old
sudo sed -e "s:# export JAVA_HOME=/usr/lib/j2sdk1.5-sun:export JAVA_HOME=${JAVA_PATH}:" /usr/local/hadoop/conf/hadoop-env.sh.old > /usr/local/hadoop/conf/hadoop-env.sh
echo "/usr/local/hadoop/conf/hadoop-env.sh updated."

  #Configure /etc/hosts
sudo cp /etc/hosts /etc/hosts.old
sudo bash -c "sed -e 's:127.0.0.1\slocalhost:127.0.0.1  ${HOST_NAME}:;s:127.0.1.1\s${HOST_NAME}::' /etc/hosts.old > /etc/hosts"
echo "/etc/hosts updated."

  #Create HDFS Directories
sudo mkdir -p /app/hadoop/tmp
sudo chown hduser:hadoop /app/hadoop/tmp
sudo chmod 750 /app/hadoop/tmp
echo "HDFS Directories (/app/hadoop/) created. Permissions set."

  #Configure /usr/local/hadoop/conf/core-site.xml
sudo cp /usr/local/hadoop/conf/core-site.xml /usr/local/hadoop/conf/core-site.xml.old
sudo sed -e "s|<configuration>|<configuration>\n<property>\n<name>fs.default.name</name>\n<value>hdfs://${MASTER_NODE_NAME}:54310</value>\n<description>Name of the default file system</description>\n</property>\n<property>\n<name>hadoop.tmp.dir</name>\n<value>/app/hadoop/tmp</value>\n<description>Base for temporary directories</description>\n</property>|" /usr/local/hadoop/conf/core-site.xml.old > /usr/local/hadoop/conf/core-site.xml
echo "/usr/local/hadoop/conf/core-site.xml updated."

  #Configure /usr/local/hadoop/conf/mapred-site.xml
sudo cp /usr/local/hadoop/conf/mapred-site.xml /usr/local/hadoop/conf/mapred-site.xml.old
sudo sed -e "s|<configuration>|<configuration>\n<property>\n<name>mapred.job.tracker</name>\n<value>${MASTER_NODE_NAME}:54311</value>\n<description>The host and port that the MapReduce job tracker runs at.</description>\n</property>\n\n<property>\n<name>mapred.local.dir</name>\n<value>\$\{hadoop.tmp.dir\}/mapred/local</value>\n</property>\n\n<property>\n<name>mapred.map.tasks</name>\n<value>20</value>\n</property>\n\n<property>\n<name>mapred.reduce.tasks</name>\n<value>2</value>\n</property>|" /usr/local/hadoop/conf/mapred-site.xml.old > /usr/local/hadoop/conf/mapred-site.xml
echo "/usr/local/hadoop/conf/mapred-site.xml updated."

  #Configure /usr/local/hadoop/conf/hdfs-site.xml
sudo cp /usr/local/hadoop/conf/hdfs-site.xml /usr/local/hadoop/conf/hdfs-site.xml.old
sudo sed -e "s|<configuration>|<configuration>\n<property>\n<name>dfs.replication</name>\n<value>${DFS_REPLICATION_COUNT}</value>\n</property>|" /usr/local/hadoop/conf/hdfs-site.xml.old > /usr/local/hadoop/conf/hdfs-site.xml
echo "/usr/local/hadoop/conf/hdfs-site.xml updated."

#Finalize the install by giving hduser permission over the Hadoop Directory
sudo chown -R hduser:hadoop /usr/local/hadoop

#Termination Message
echo "This worker node is ready to go! Make sure your master:conf/slaves file contains the host name of this node. HDFS must be reformatted as well."