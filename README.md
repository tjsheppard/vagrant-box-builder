# Vagrant WebDev Starter Kit :

Vagrant can be a bit confusing at first so this Starter 

Before this can work you have to have a few things installed obviously.

# 1. Installation 💾

[Oracle VM VirtualBox](https://www.virtualbox.org/)

[Vagrant by HashiCorp](https://www.vagrantup.com/)

[dotless-de/vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

This plugin is needed to allow synced folders functionality to work. Once *Vagrant* and *Virtualbox* are installed run this command get it:

    vagrant plugin install vagrant-vbguest

# 2. Define your box 📦

Clone the repository or download the zip.

For starters create a folder outside the downloaded folder as the name of your project.

Once the machine is finished it is recommended you do a `vagrant reload`.

    vagrant reload

The reason for this is for SElinux to be completed disabled it needs to switch off. Plus it's a good test to make sure everything boots up properly when you shut the box down.

# 3. Your machine 🔐

vagrant ssh - you should see an imformative message when booting up your box telling you the ip and it's name. Lovely.

On your mac go to the hosts file and add your ip address with the our local dns

    sudo nano /etc/hosts

    123.4.5.6     dinosaurs.local
    123.4.5.6     www.dinosaurs.local

Great but if you go to the sites httpd connection you'll see this

Next you need to add the PEM file to your keychain so 

# 4. Complete 🌈

Blah blah stuff will go here