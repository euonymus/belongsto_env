apt_repository 'ondrej-php' do
  uri        'ppa:ondrej/php'
end

include_recipe "php"
include_recipe 'php::module_mysql'
include_recipe 'php::module_curl'
include_recipe 'php::module_sqlite3' # for debug_kit

# Copy the php.ini for cli into apaches dir
# commented out because IO.read fails
# file node[:belongsto][:php_conf_dir_apache] + '/php.ini' do
#   content IO.read(node[:belongsto][:php_conf_dir_cli] + '/php.ini')
# end
execute "copy php.ini for apache" do
  command "cp -p " + node[:belongsto][:php_conf_dir_cli] + '/php.ini ' + node[:belongsto][:php_conf_dir_apache] + '/php.ini'
end
