Vagrant.configure("2") do |config|
  config.vm.network "private_network", type: "dhcp"
  config.vm.usable_port_range = 8000..8999
  config.vm.network "forwarded_port", guest: 80, host: 8000, id: 'http', auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 8001, id: 'https', auto_correct: true
  config.vm.network "forwarded_port", guest: 3306, host: 8002, id: 'mysql',auto_correct: true
  config.ssh.insert_key = false

  config.vm.define "dinosaurs" do |box|
    #######################################
    name = "dinosaurs"
    ext = ".rawr"
    os = "centos/7"
    php = 72
    gituser = "Tom Sheppard"
    gitemail = "sheppardnexus@gmail.com"
    #######################################
    box.vm.box = os
    box.vm.hostname = name
    box.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    box.vm.provision "shell", path: "provisions/provision.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail]
    box.vm.provision "shell", path: "provisions/boot.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail], run: "always"
    box.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = name
    end
  end

  config.vm.define "homo-sapiens" do |box|
    #######################################
    name = "homo-sapiens"
    ext = ".earth"
    os = "centos/7"
    php = 56
    gituser = "Tom Sheppard"
    gitemail = "sheppardnexus@gmail.com"
    #######################################
    box.vm.box = os
    box.vm.hostname = name
    box.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    box.vm.provision "shell", path: "provisions/provision.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail]
    box.vm.provision "shell", path: "provisions/boot.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail], run: "always"
    box.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = name
    end
  end

  config.vm.define "atheneum" do |box|
    #######################################
    name = "atheneum"
    ext = ".books"
    os = "ubuntu/bionic64"
    php = 72
    gituser = "Tom Sheppard"
    gitemail = "sheppardnexus@gmail.com"
    #######################################
    box.vm.box = os
    box.vm.hostname = name
    box.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    # box.vm.provision "shell", path: "provisions/provision.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail]
    # box.vm.provision "shell", path: "provisions/boot.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail], run: "always"
    box.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = name
    end
  end

  config.vm.define "centos" do |box|
    #######################################
    name = "centos"
    ext = ".local"
    os = "centos/7"
    gituser = "Tom Sheppard"
    gitemail = "sheppardnexus@gmail.com"
    #######################################
    php = 70
    box.vm.box = os
    box.vm.hostname = name
    box.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    box.vm.provision "shell", path: "provisions/provision.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail]
    box.vm.provision "shell", path: "provisions/boot.sh", privileged: false, :args => [name, ext, os, php, gituser, gitemail], run: "always"
    box.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = name
    end
  end

end