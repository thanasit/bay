#!/usr/bin/env bash

# Adding PostgreSQL Yum Repository
sudo rpm -Uvh https://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
# Installing PostgreSQL Server
sudo yum install -y postgresql96-server postgresql96
# Initializing PGDATA
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
#sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb -D /mnt/db/pgsql/9.6/data/
# PostgreSQL data directory Path: /var/lib/pgsql/9.6/data/
# Start PostgreSQL Server
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6
# Verify PostgreSQL Installation
#sudo su - postgres
#psql
# Setup
#ALTER USER postgres PASSWORD 'password';
#CREATE USER rhqadmin PASSWORD 'rhqadmin';
#CREATE DATABASE rhq OWNER rhqadmin;
#\q
#exit
# Configure
sudo cp -r /vagrant/* /var/lib/pgsql/9.6/data/
#sudo chown -R postgres:postgres
sudo systemctl restart postgresql-9.6