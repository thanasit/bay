# BAY
JBOSS Operation Network and HA proxy

````bash
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

After JON box is it up, then following command as below.
````bash
$ vagrant ssh jon
````

JON Installation
````bash
$ sudo useradd jboss
$ sudo passed jboss
````

Copy `jon-server-3.3.0.GA.zip` to `/apps/jon/` destination path. Next step create link JON server.
````bash
$ cd /apps/jon
$ sudo unzip jon-server-3.3.0.GA.zip
$ sudo ln -s /apps/jon/jon-server-3.3.0.GA/ /apps/jon/current
$ sudo mv /apps/jon/current/bin/rhq-server.properties /apps/jon/current/bin/rhq-server.properties.org 
$ sudo cp /vagrant/rhq-server.properties /apps/jon/current/bin/
$ sudo ./rhqclt install --start

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
$ sudo ./rhqctl restart
````

The server URL is https://hostname:7443. For example: 
````text
https://192.168.20.55:7443
````

**HA proxy**
