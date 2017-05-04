#!/usr/bin/env bash
sudo yum info haproxy
sudo yum install -y wget gcc openssl-devel pcre-static pcre-devel
sudo tar xzvf /home/vagrant/haproxy-1.5.3.tar.gz
cd /home/vagrant/haproxy-1.5.3
sudo make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_CRYPT_H=1 USE_LIBCRYPT=1
sudo make install
sudo cp /usr/local/sbin/haproxy /usr/sbin/
sudo cp /home/vagrant/haproxy-1.5.3/examples/haproxy.init /etc/init.d/haproxy
sudo chmod 755 /etc/init.d/haproxy
sudo mkdir -p /etc/haproxy
sudo mkdir -p /run/haproxy
sudo mkdir -p /var/lib/haproxy
sudo touch /var/lib/haproxy/stats
sudo haproxy -vv
sudo cp  /home/vagrant/haproxy-http.xml /etc/firewalld/services/haproxy-http.xml
sudo cp  /home/vagrant/haproxy-https.xml /etc/firewalld/services/haproxy-https.xml
sudo restorecon /etc/firewalld/services/haproxy-http.xml
sudo chmod 640 /etc/firewalld/services/haproxy-http.xml
sudo restorecon /etc/firewalld/services/haproxy-https.xml
sudo chmod 640 /etc/firewalld/services/haproxy-https.xml

sudo cp /home/vagrant/haproxy.cfg /etc/haproxy/
sudo mkdir -p /etc/haproxy/sslkeys
sudo cp /home/vagrant/private/marlo.com.au.local.pem /etc/haproxy/sslkeys/
sudo systemctl enable haproxy
sudo systemctl start haproxy
sudo setsebool -P haproxy_connect_any=1