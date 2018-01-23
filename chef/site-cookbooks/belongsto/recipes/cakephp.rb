# -*- coding: utf-8 -*-
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


# Build app.php files
template node[:belongsto][:cake_source] + '/config/app.php' do
  source 'app.php.erb'
  owner "www-data"
  group "www-data"
  mode "755"
  variables({
     :login         => node[:belongsto][:db_user],
     :database      => node[:belongsto][:db_name],
     :password      => node[:belongsto][:db_password],
  })
end


# Build secrets.php files
template node[:belongsto][:cake_source] + '/config/secrets.php' do
  source 'secrets.php.erb'
  owner "www-data"
  group "www-data"
  mode "755"
  variables({
     :mskey      => node[:belongsto][:mskey],
  })
end


# Database Table creation
execute "create_tables" do
  command 'cd ' + node[:belongsto][:cake_source] + " && bin/cake migrations migrate"
end

# Change setting for text field by alter table
execute "init_subject_search" do
  command "mysql -S /var/run/mysql-" + node[:belongsto][:app_name] + "/mysqld.sock -u" + node[:belongsto][:db_user] + " -p" + node[:belongsto][:db_password] + " " + node[:belongsto][:db_name] + " -e'ALTER TABLE `subject_searches` MODIFY `search_words` TEXT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci` NOT NULL;'"
end

# make it myisam
execute "init_subject_search" do
  command "mysql -S /var/run/mysql-" + node[:belongsto][:app_name] + "/mysqld.sock -u" + node[:belongsto][:db_user] + " -p" + node[:belongsto][:db_password] + " " + node[:belongsto][:db_name] + " -e'ALTER TABLE `subject_searches` ENGINE = MyISAM;'"
end


# cron
