required_plugins = %w(vagrant-vbguest)
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure("2") do |config|

  # This is the jon server host
  config.vm.define "jon" do |jon|
    jon.vm.box = "centos/7"
    jon.vm.hostname = "jon"
    jon.vm.synced_folder "./jon/", "/vagrant", rsync__exclude: ".git/ ./haproxy"
    jon.vm.network "private_network", ip: "192.168.20.55", :netmask => "255.255.255.0",  auto_config: true
    jon.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    jon.vm.provision :shell, path: "scripts/javaInstall.sh"
    jon.vm.provision :shell, path: "scripts/passwordAuthentication.sh"
#    jon.vm.provision "shell", inline: <<-SHELL
#      SHELL
    
  end

  #This is the haproxy host
  config.vm.define "haproxy" do |haproxy_config|
    haproxy_config.vm.box = "centos/7"
    haproxy_config.vm.hostname = "haproxy"
    haproxy_config.vm.synced_folder "./haproxy/", "/vagrant", rsync__exclude: ".git/"
    haproxy_config.vm.network "private_network", ip: "192.168.20.50", :netmask => "255.255.255.0",  auto_config: true
    haproxy_config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    haproxy_config.vm.provision :shell, path: "scripts/passwordAuthentication.sh"
    haproxy_config.vm.provision "shell", inline: <<-SHELL
        sudo cp -r /vagrant/* /home/vagrant/
        #sudo chown -R vagrant:vagrant /home/vagrant/*
        if [ "`systemctl is-active firewalld`" == "active" ]; then
          echo "Firewalld is actived"
        else
          sudo systemctl enable firewalld
          sudo systemctl start firewalld
          sudo firewall-cmd --zone=public --add-port 80/tcp --permanent
          sudo firewall-cmd --zone=public --add-port 443/tcp --permanent
          sudo firewall-cmd --reload
          sudo firewall-cmd --list-ports
        fi
    SHELL
    haproxy_config.vm.provision :shell, path: "scripts/javaInstall.sh"
    haproxy_config.vm.provision :shell, path: "scripts/keepalivedInstall.sh"
    haproxy_config.vm.provision :shell, path: "scripts/haproxyInstall.sh"

  end

end