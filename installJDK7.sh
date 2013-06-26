#!/bin/sh
#Author: Akhil A. Saji (asaji@bu.edu)
#Script that installs JDK7 Rev. 25; Please keep a copy of the tar.gz; 
#If you recieve a wget error, place tar.gz in the same directory as this script and run.

wget http://asaji.webfactional.com/file_stack/linuxRepo/jdk-7u25-linux-x64.tar.gz
tar -xvf jdk-7u25-linux-x64.tar.gz
sudo mkdir /usr/lib/jvm
sudo mv ./jdk1.7.0_25 /usr/lib/jvm
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0_25/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0_25/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.7.0_25/bin/javaws" 1
sudo update-alternatives --install "/usr/bin/jps" "jps" "/usr/lib/jvm/jdk1.7.0_25/bin/jps" 1
sudo chmod a+x /usr/bin/java
sudo chmod a+x /usr/bin/javac
sudo chmod a+x /usr/bin/javaws
sudo chmod a+x /usr/bin/jps
java -version
echo JDK successfully installed at : /usr/lib/jvm/jdk1.7.0_25