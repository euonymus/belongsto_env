# -*- coding: utf-8 -*-
# install php intl extension as cakephp 3.x requires
execute "install_intl_extension" do
  command "sudo apt-get install php5-intl"
end

# disable apache event mpm mode
execute "disable_mpm_event" do
  command "a2dismod mpm_event"
end

# enable apache prefork mpm mode
execute "enable_mpm_prefork" do
  command "a2enmod mpm_prefork"
end

# apache restart
execute "apache_restart" do
  command "apachectl graceful"
end

link "/var/opt/host.php" do
  to node[:belongsto][:app_root] + "/config/host.php." + node.chef_environment
end


# delete a tmp directory
directory node[:belongsto][:cake_source] + "/tmp" do
  recursive true
  action :delete
end

# create a tmp directory
directory node[:belongsto][:cake_source] + '/tmp' do
  owner "www-data"
  group "www-data"
  mode "0775"
  action :create
end

# delete a logs directory
directory node[:belongsto][:cake_source] + "/logs" do
  recursive true
  action :delete
end

# create a logs directory
directory node[:belongsto][:cake_source] + '/logs' do
  owner "www-data"
  group "www-data"
  mode "0775"
  action :create
end



# Database Table creation



# cron
