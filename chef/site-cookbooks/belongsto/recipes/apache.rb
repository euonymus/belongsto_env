directory(node[:belongsto][:www_root])

# put apache config
web_app(node[:belongsto][:app_name]) do
  server_name(node[:belongsto][:server_name])
  docroot(node[:belongsto][:app_root])
  template('vhost.conf.erb')
end

if node.chef_environment != 'virtualbox'
  link node[:belongsto][:app_root] do
    to node[:belongsto][:cake_source]
  end
end
