# -*- coding: utf-8 -*-
# MySQL auto restart setting
execute "set auto restart" do
  command "sudo sysv-rc-conf mysql-" + node[:belongsto][:app_name] + " on"
end

mysql_service node[:belongsto][:app_name] do
  port '3306'
  version '5.6'
  initial_root_password node[:belongsto][:db_password_root]
  action [:create, :start]
end

# Since database cookbook(4.0.7) requires manual install for mysql2_chef_gem
mysql2_chef_gem 'default' do
  client_version '5.6'
  action :install
end

# This is used repeatedly, so we'll store it in a variable
mysql_connection_info = {
  host:     'localhost',
  username: 'root',
  password: node[:belongsto][:db_password_root],
  socket:   '/var/run/mysql-' + node[:belongsto][:app_name] + '/mysqld.sock'
}

# Ensure a database exists with the name of our app
mysql_database node[:belongsto][:db_name] do
  connection mysql_connection_info
  action     :create
end
mysql_database node[:belongsto][:testdb_name] do
  connection mysql_connection_info
  action     :create
end

# Ensure a database user exists with the name of our app
mysql_database_user node[:belongsto][:db_user] do
  connection mysql_connection_info
  password   node[:belongsto][:db_password]
  action     :create
end
mysql_database_user node[:belongsto][:testdb_user] do
  connection mysql_connection_info
  password   node[:belongsto][:db_password]
  action     :create
end

# Let this database user access this database
mysql_database_user node[:belongsto][:db_user] do
  mysql_connection_info
  password      node[:belongsto][:db_password]
  database_name node[:belongsto][:db_name]
  host          'localhost'
  action        :grant
end
mysql_database_user node[:belongsto][:testdb_user] do
  mysql_connection_info
  password      node[:belongsto][:db_password]
  database_name node[:belongsto][:testdb_name]
  host          'localhost'
  action        :grant
end

# MySQL timezone 設定
execute "set timezone info into mysql database" do
  command "mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -S /var/run/mysql-" + node[:belongsto][:app_name] + "/mysqld.sock -p" + node[:belongsto][:db_password_root] + " mysql"
end


# build mysite.cnf for mysql config
template '/etc/mysql-' + node[:belongsto][:app_name] + '/conf.d/mysite.cnf' do
  owner 'mysql'
  owner 'mysql'
  source 'mysite.cnf.erb'
  notifies :restart, 'mysql_service[' + node[:belongsto][:app_name] + ']'
end

# restart mysql
execute "stop_mysql" do
  command "sudo service mysql-" + node[:belongsto][:app_name] + " stop"
end
execute "start_mysql" do
  command "sudo service mysql-" + node[:belongsto][:app_name] + " start"
end

