#!/usr/bin/env bash
java -version
if [ $? == 0 ] && [[-n $JAVA_HOME]]; then
  echo "JAVA INSTALLED: " $JAVA_HOME
else
  sudo yum install -y java-1.8.0-openjdk 
  sudo echo "export JAVA_HOME=/usr/lib/jvm/jre/bin" >> /etc/bashrc
  export JAVA_HOME=/usr/lib/jvm/jre/bin
fi
echo "JAVA INSTALLED: " $JAVA_HOME