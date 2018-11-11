Vagrant.configure("2") do |config|
  config.vm.network "private_network", type: "dhcp"
  config.vm.usable_port_range = 8000..8999
  config.vm.network "forwarded_port", guest: 80, host: 8000, id: 'http', auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 8001, id: 'https', auto_correct: true
  config.ssh.insert_key = false

  config.vm.define "dinosaurs" do |box|
    #######################################
    name = "dinosaurs"
    ext = "rawr"
    os = "centos/7"
    php = 72
    gituser = "Tom Sheppard"
    gitemail = "tomsheppard@email.com"
    subdomain = "jurassic"
    #######################################
    box.vm.box = os
    box.vm.hostname = name
    box.vm.synced_folder "../" + name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    box.vm.provision "shell", path: "provision.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail, subdomain]
    box.vm.provision "shell", path: "boot.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail, subdomain], run: "always"
    box.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = name
    end
  end





  config.vm.define "atheneum" do |box|
    #######################################
    name = "atheneum"
    ext = "books"
    os = "ubuntu/bionic64"
    php = 72
    gituser = "Tom Sheppard"
    gitemail = "sheppardnexus@gmail.com"
    subdomain = "books"
    #######################################
    box.vm.box = os
    box.vm.hostname = name
    box.vm.synced_folder "../" + name + "/", "/var/www/", owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    box.vm.provision "shell", path: "provision.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail, subdomain]
    box.vm.provision "shell", path: "boot.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail, subdomain], run: "always"
    box.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = name
    end
  end

end