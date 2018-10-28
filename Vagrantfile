Vagrant.configure("2") do |config|
  name = "ilovecats"
  config.vm.hostname = name
  config.vm.box = "centos/7"
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.ssh.insert_key = false
  config.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
  config.vm.provision "shell", path: "centos.sh", privileged: false, :args => [name]
  config.vm.provision "shell", path: "boot.sh", privileged: false, :args => [name], run: "always"
end