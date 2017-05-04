#!/usr/bin/env bash
sudo yum install -y keepalived
sudo mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.org
sudo cp /home/vagrant/keepalived.conf /etc/keepalived/keepalived.conf
sudo systemctl enable keepalived
sudo systemctl start keepalived