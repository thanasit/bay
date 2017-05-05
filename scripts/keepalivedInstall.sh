#!/usr/bin/env bash
if [ "`systemctl is-active keepalived`" == "active" ]; then
    echo "Keepalived is actived"
else
    sudo yum install -y keepalived
    sudo mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.org
    sudo cp -r /home/vagrant/keepalived.conf /etc/keepalived/keepalived.conf
    sudo systemctl enable keepalived
    sudo systemctl start keepalived
fi