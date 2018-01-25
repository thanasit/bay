#!/usr/bin/env bash
java -version
if [ $? == 0 ] && [[-n $JAVA_HOME]]; then
  echo "JAVA INSTALLED: " $JAVA_HOME
else
  sudo yum install -y java-1.8.0-openjdk-devel 
  sudo echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64' >> /etc/profile
  sudo echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile
  sudo echo 'export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar' >> /etc/profile
  source /etc/profile
fi
echo "JAVA INSTALLED: " $JAVA_HOME