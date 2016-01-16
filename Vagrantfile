# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

settings = YAML.load_file 'vagrant.yml'

puts settings 

if ! File.exists?(".vagrant/machines/default/virtualbox/id")
  print "Write sync folder full path: "
  settings['sync_folder'] = STDIN.gets.chomp
  File.open('vagrant.yml','w') do |h| 
   h.write settings.to_yaml
  end
  print "Write GitHub login: "
  github_login = STDIN.gets.chomp
  print "Write GitHub password: "
  github_password = STDIN.gets.chomp
  print "Write new postgres password: "
  postgres_password = STDIN.gets.chomp
end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |v|
	v.memory = 1024
	v.cpus = 2
  end
  
  # Create a private network, which allows host-only access to the machine using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.22"

  # Share an additional folder to the guest VM. The first argument is the path on the host to the actual folder.
  # The second argument is the path on the guest to mount the folder.
  
  config.vm.synced_folder settings['sync_folder'], "/var/www/html"

  FileUtils.cp './init.php', settings['sync_folder'] + '\init.php'

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision "shell" do |s|
	s.path = "bootstrap.sh"
    s.args   = "#{github_login} #{github_password} #{postgres_password}"
  end

end
