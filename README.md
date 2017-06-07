BAY
=======================================================
JBOSS Operation Network and HA proxy

````text
$ vagrant up jon
==> jon: Checking if box 'centos/7' is up to date...
==> jon: Clearing any previously set forwarded ports...
==> jon: Clearing any previously set network interfaces...
==> jon: Preparing network interfaces based on configuration...
    jon: Adapter 1: nat
    jon: Adapter 2: hostonly
==> jon: Forwarding ports...
    jon: 22 (guest) => 2222 (host) (adapter 1)
==> jon: Running 'pre-boot' VM customizations...
==> jon: Booting VM...
==> jon: Waiting for machine to boot. This may take a few minutes...
    jon: SSH address: 127.0.0.1:2222
    jon: SSH username: vagrant
    jon: SSH auth method: private key
    jon: Warning: Remote connection disconnect. Retrying...
==> jon: Machine booted and ready!

$ vagrant up haproxy
==> haproxy: Checking if box 'centos/7' is up to date...
==> haproxy: Clearing any previously set forwarded ports...
==> haproxy: Clearing any previously set network interfaces...
==> haproxy: Preparing network interfaces based on configuration...
    haproxy: Adapter 1: nat
    haproxy: Adapter 2: hostonly
==> haproxy: Forwarding ports...
    haproxy: 22 (guest) => 2222 (host) (adapter 1)
==> haproxy: Running 'pre-boot' VM customizations...
==> haproxy: Booting VM...
==> haproxy: Waiting for machine to boot. This may take a few minutes...
    haproxy: SSH address: 127.0.0.1:2222
    haproxy: SSH username: vagrant
    haproxy: SSH auth method: private key
    haproxy: Warning: Remote connection disconnect. Retrying...
==> haproxy: Machine booted and ready!
````

**JON**
------------------------------------------------------

After JON box is it up, then following command as below.
````bash
$ vagrant ssh jon
````

Databases (Postgresql) Configuration
````text
$ su - postgres
$ psql

postgres=# ALTER USER postgres PASSWORD 'password';
ALTER ROLE
postgres=# CREATE USER rhqadmin PASSWORD 'rhqadmin';
CREATE ROLE
postgres=# CREATE DATABASE rhq OWNER rhqadmin;
CREATE DATABASE
````

Then, restart the database service.
````bash
$ sudo systemctl enable postgres-9.6
$ sudo systemctl restart postgres-9.6
````

JON Installation
````bash
$ sudo useradd --no-create-home --system --user-group jon
$ sudo passwd -d jon
$ sudo usermod -aG wheel jon
````

Copy `jon-server-3.3.0.GA.zip` to `/apps/jon/` destination path. Next step create link JON server.
````bash
$ cd /apps/jon
$ sudo unzip jon-server-3.3.0.GA.zip
$ sudo ln -s /apps/jon/jon-server-3.3.0.GA/ /apps/jon/current
$ sudo mv /apps/jon/current/bin/rhq-server.properties /apps/jon/current/bin/rhq-server.properties.org 
$ sudo cp /vagrant/rhq-server.properties /apps/jon/current/bin/
$ sudo chown -r jon:jon /apps/jon
$ su -m jon -c './apps/jon/current/bin/rhqclt install --start'

06:21:40,773 INFO  [org.jboss.modules] JBoss Modules version 1.3.3.Final-redhat-1

The [rhq.autoinstall.server.admin.password] property is required but not set in [rhq-server.properties].
Do you want to set [rhq.autoinstall.server.admin.password] value now?
yes|no: yes
rhq.autoinstall.server.admin.password (enter as plain text): 
Confirm:
rhq.autoinstall.server.admin.password (enter as plain text): 

The [jboss.bind.address] property is required but not set in [rhq-server.properties].
Do you want to set [jboss.bind.address] value now?
yes|no: yes
jboss.bind.address: 0.0.0.0
Is [0.0.0.0] correct?
yes|no: yes
````

The server URL is http://hostname:7080. For example: 
````text
http://192.168.20.55:7080
````

**Securing server and agent communications**
------------------------------------------------------

JON server can be disabled by making the following change to ``${RHQ_SERVER_HOME}/bin/rhq-server.properties``
````smartyconfig
rhq.server.socket.binding.port.http=0
````

Enable SSL/TLS encryption
````smartyconfig
rhq.communications.connector.transport=sslservlet
````

Restart JON server
````bash
$ su -m jon -c './apps/jon/current/bin/rhqclt restart'
````

The server URL is https://hostname:7443. For example: 
````text
https://192.168.20.55:7443
````

**HA proxy**
------------------------------------------------------

Installation
````text
$ sudo yum info haproxy
$ cd /home/vagrant/
$ sudo tar -xzvf /home/vagrant/haproxy-1.5.3.tar.gz
$ cd /home/vagrant/haproxy-1.5.3/
$ sudo make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_CRYPT_H=1 USE_LIBCRYPT=1
$ sudo make install
$ sudo cp -r /usr/local/sbin/haproxy /usr/sbin/
$ sudo cp -r /home/vagrant/haproxy-1.5.3/examples/haproxy.init /etc/init.d/haproxy
$ sudo chmod 755 /etc/init.d/haproxy
$ sudo mkdir -p /etc/haproxy
$ sudo mkdir -p /run/haproxy
$ sudo mkdir -p /var/lib/haproxy
$ sudo touch /var/lib/haproxy/stats
$ sudo haproxy -vv
````

Selinux for Centos 7
````text
$ sudo cp -r /home/vagrant/haproxy-http.xml /etc/firewalld/services/haproxy-http.xml
$ sudo cp -r /home/vagrant/haproxy-https.xml /etc/firewalld/services/haproxy-https.xml
$ sudo restorecon /etc/firewalld/services/haproxy-http.xml
$ sudo chmod 640 /etc/firewalld/services/haproxy-http.xml
$ sudo restorecon /etc/firewalld/services/haproxy-https.xml
$ sudo chmod 640 /etc/firewalld/services/haproxy-https.xml
# $ sudo firewall-cmd --zone=public --add-service=haproxy-http --permanent
# $ sudo firewall-cmd --zone=public --add-service=haproxy-https --permanent
# $ sudo firewall-cmd --reload
````

Selinux for Centos 6
````text
# To be continue
````

Create user
````text
$ sudo id -u haproxy &>/dev/null || useradd -s /usr/sbin/nologin -r haproxy
````

Configuration and SSL
````text
$ sudo cp -r /home/vagrant/haproxy.cfg /etc/haproxy/
$ sudo mkdir -p /etc/haproxy/sslkeys
$ sudo cp -r /home/vagrant/private/marlo.com.au.local.pem /etc/haproxy/sslkeys/
````

Enable service
````text
$ sudo chkconfig haproxy on
$ sudo chkconfig --level 2345 haproxy on
````

Add Selinux policy
````text
$ sudo setsebool -P haproxy_connect_any=1
````

After done restart server.
````text
$ sudo shutdown -r 0
````
