# BAY
JBOSS Operation Network

````
# vagrant up
````

After JON box is it up, then following command as below.

````
# vagrant ssh jon
````

JON Installation
````
# sudo useradd jboss
# sudo passed jboss
````
Copy `jon-server-3.3.0.GA.zip` to `/apps/jon/` destination path. Next step create link JON server.
````
# cd /apps/jon
# sudo unzip jon-server-3.3.0.GA.zip
# ln -s /apps/jon/jon-server-3.3.0.GA/ /apps/jon/current
````