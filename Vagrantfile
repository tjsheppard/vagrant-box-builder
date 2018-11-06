Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", type: "dhcp"
  config.vm.usable_port_range = 8000..8999
  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.ssh.insert_key = false

  config.vm.define "cats" do |cats|
    name = 'cats'
    cats.vm.hostname = name
    cats.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    cats.vm.provision "shell", path: "provisions/centos.sh", privileged: false, :args => [name]
    cats.vm.provision "shell", path: "provisions/boot.sh", privileged: false, :args => [name], run: "always"
    cats.vm.provider "virtualbox" do |v|
      v.name = name
    end
  end

  config.vm.define "dogs" do |dogs|
    name = 'dogs'
    dogs.vm.hostname = name
    dogs.vm.synced_folder name + "/", "/var/www/",  owner: "root", group: "root", mount_options: ["dmode=777", "fmode=666"]
    dogs.vm.provision "shell", path: "provisions/centos.sh", privileged: false, :args => [name]
    dogs.vm.provision "shell", path: "provisions/boot.sh", privileged: false, :args => [name], run: "always"
    dogs.vm.provider "virtualbox" do |v|
      v.name = name
    end
  end

end