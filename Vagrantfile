# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  load 'src/hosts/host_settings.rb'

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu14_04_x64"
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./src/cakephp", "/var/www/cakephp", id: "vagrant-root",
    owner: "www-data",
    group: "www-data",
    #mount_options: ["dmode=775,fmode=664"]
    mount_options: ["dmode=775"]

  # config.vm.provider 'digital_ocean' do |vb, ovr|
  #   ovr.ssh.private_key_path = PRIVATE_KEY_PATH
  #   ovr.vm.box = "digital_ocean"
  #   ovr.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
  #   ovr.vm.hostname = HOSTNAME

  #   vb.token = TOKEN
  #   vb.ssh_key_name = SSH_KEYNAME
  #   vb.image = 'ubuntu-14-04-x64'
  #   vb.region = 'sgp1'
  #   vb.size = '512MB'
  # end
  # ENV['VAGRANT_DEFAULT_PROVIDER'] = 'digital_ocean'


  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.


  config.vm.provision "chef_solo" do |chef|
    #chef.cookbooks_path = "chef/cookbooks/"
    chef.cookbooks_path = ["chef/cookbooks", "chef/site-cookbooks"]
    # chef.nodes_path = "chef/nodes"
    chef.data_bags_path = "chef/data_bags"
    chef.environment = CHEF_ENVIRONMENT
    chef.environments_path = "chef/environments"
    chef.run_list = %w[
      recipe[apt]
      recipe[git]
      recipe[vim]
      recipe[apache2]
      recipe[apache2::mod_auth_basic]
      recipe[apache2::mod_php5]
      recipe[apache2::mod_rewrite]
      recipe[apache2::mod_deflate]
      recipe[apache2::mod_headers]
      recipe[apache2::mod_ssl]
      recipe[apache2::mod_vhost_alias]
      recipe[postfix]
      recipe[belongsto]
    ]
      # recipe[iptables]

    # Put iptables to the above, if you want to
    # recipe[iptables]
  end
  # config.omnibus.chef_version = :latest
  # Chef's latest version, 12.11.18 has a bug with vagrant
  config.omnibus.chef_version = "12.10.24"




  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
