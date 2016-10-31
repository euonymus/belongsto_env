default[:belongsto][:app_name]     = 'cakephp'

default[:belongsto][:production]   = 'belongsto.com'
default[:belongsto][:development]  = 'dev.belongsto.com'
default[:belongsto][:personal]     = 'personal.belongsto.com'
default[:belongsto][:virtualbox]   = 'virtualbox.belongsto.com'
default[:belongsto][:server_name]  = default[:belongsto][node.chef_environment]

default[:belongsto][:www_root]     = "/var/www"
default[:belongsto][:cache_root]   = "/var/cache"
default[:belongsto][:log_root]     = "/var/log"
default[:belongsto][:app_root]     = "#{node[:belongsto][:www_root]}/#{node[:belongsto][:app_name]}"

default[:belongsto][:db_name]      = 'belongsto'
default[:belongsto][:db_user]      = 'belongsto'
default[:belongsto][:testdb_name]  = 'test_belongsto'
default[:belongsto][:testdb_user]  = 'belongsto'

default[:belongsto][:cake_source]  = '/vagrant/src/cakephp'
default[:belongsto][:cake_cache]   = "#{node[:belongsto][:cache_root]}/#{node[:belongsto][:app_name]}"
default[:belongsto][:cake_log]     = "#{node[:belongsto][:log_root]}/#{node[:belongsto][:app_name]}"

default[:belongsto][:shell_base]  = '/usr/local/bin'


# The path to the data_bag_key on the virtualbox server
default[:belongsto][:secretpath] = "/vagrant/src/secrets/data_bag_key"

# look for secret in file pointed to with belongsto attribute :secretpath
data_bag_secret = Chef::EncryptedDataBagItem.load_secret("#{node[:belongsto][:secretpath]}")

# Set MySQL passwords from data_bag
mysql_creds = Chef::EncryptedDataBagItem.load("passwords", "mysql", data_bag_secret)
if data_bag_secret && mysql_passwords = mysql_creds[node.chef_environment]
  default[:belongsto][:db_password_root] = mysql_passwords['root']
  default[:belongsto][:db_password] = mysql_passwords['app']
end


# php.ini
# MEMO: I tried to change the version of php, but failed, so I just commented out
# default['php']['version'] = '5.5.24'
# node.set_unless['php']['version'] = '5.5.24'
default['php']['directives'] = {
  "date.timezone" => "Asia/Tokyo",
  "short_open_tag" => "On",
  "memory_limit" => "128M"
}
default[:belongsto][:php_conf_dir_apache] = '/etc/php5/apache2'
default[:belongsto][:php_conf_dir_cli] = '/etc/php5/cli'


case node["platform_family"]
when "rhel", "fedora"
  if node['platform_version'].to_f < 6 then
    default['php']['packages'] = ['php53', 'php53-devel', 'php53-cli', 'php53-mbstring', 'php-pear']
  else
    default['php']['packages'] = ['php', 'php-devel', 'php-cli', 'php-mbstring', 'php-pear']
  end
end
