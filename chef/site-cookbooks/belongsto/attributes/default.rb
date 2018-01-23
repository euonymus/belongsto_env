default[:belongsto][:app_name]     = 'cakephp'

default[:belongsto][:production]   = 'gluons.link'
default[:belongsto][:development]  = 'dev.gluons.link'
default[:belongsto][:personal]     = 'personal.gluons.link'
default[:belongsto][:virtualbox]   = 'virtualbox.gluons.link'
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



# Set MS_KEY from data_bag
mskey_creds = Chef::EncryptedDataBagItem.load("passwords", "mskey", data_bag_secret)
if data_bag_secret && mskey = mskey_creds[node.chef_environment]
  default[:belongsto][:mskey] = mskey['mskey']
end


# php.ini
default['php']['directives'] = {
  "date.timezone" => "Asia/Tokyo",
  "short_open_tag" => "On",
  "memory_limit" => "128M"
}
default[:belongsto][:php_conf_dir_apache] = '/etc/php/7.1/apache2'
default[:belongsto][:php_conf_dir_cli] = '/etc/php/7.1/cli'


# case node["platform_family"]
# when "rhel", "fedora"
#   if node['platform_version'].to_f < 6 then
#     default['php']['packages'] = ['php53', 'php53-devel', 'php53-cli', 'php53-mbstring', 'php-pear']
#   else
#     default['php']['packages'] = ['php', 'php-devel', 'php-cli', 'php-mbstring', 'php-pear']
#   end
# end

default['php']['conf_dir'] = '/etc/php/7.1/cli'
default['php']['ext_conf_dir']  = '/etc/php/7.1/apache2/conf.d'
default['php']['src_deps']         = %w(libbz2-dev libc-client2007e-dev libcurl4-gnutls-dev libfreetype6-dev libgmp3-dev libjpeg62-dev libkrb5-dev libmcrypt-dev libpng12-dev libssl-dev pkg-config)

default['php']['packages'] = %w(php7.1 libapache2-mod-php7.1 php7.1-cli php7.1-common php7.1-mbstring php7.1-gd php7.1-intl php7.1-xml php7.1-mcrypt php7.1-zip php-pear)
default['php']['mysql']['package'] = 'php7.1-mysql'
default['php']['curl']['package']  = 'php7.1-curl'

default['php']['apc']['package']   = 'php-apc'
default['php']['apcu']['package']  = 'php-apcu'
default['php']['gd']['package']    = 'php7.1-gd'
default['php']['ldap']['package']  = 'php7.1-ldap'
default['php']['pgsql']['package'] = 'php7.1-pgsql'
default['php']['sqlite']['package'] = 'php7.1-sqlite3'

default['php']['fpm_package']   = 'php7.1-fpm'
default['php']['fpm_pooldir']   = '/etc/php/7.1/fpm/pool.d'
default['php']['fpm_user']      = 'www-data'
default['php']['fpm_group']     = 'www-data'
default['php']['fpm_listen_user']  = 'www-data'
default['php']['fpm_listen_group'] = 'www-data'
default['php']['fpm_service']      = 'php7.1-fpm'

default['php']['fpm_socket']       = '/var/run/php/php7.1-fpm.sock'
default['php']['fpm_default_conf'] = '/etc/php/7.1/fpm/pool.d/www.conf'
default['php']['fpm_default_conf'] = '/etc/php/7.1/fpm/pool.d/www.conf'
default['php']['enable_mod']       = '/usr/sbin/phpenmod'
default['php']['disable_mod']      = '/usr/sbin/phpdismod'
default['php']['ext_conf_dir']     = '/etc/php/7.1/mods-available'
