#
# Cookbook Name:: belongsto
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Change the timezone to JST. Step1: cp original localtime file for backup
file "/etc/localtime.org" do
  content IO.read("/etc/localtime")
  not_if { File.exists?("/etc/localtime.org") }
end
# Change the timezone to JST. Step2: create symlink to Tokyo region
link '/etc/localtime' do
  to '/usr/share/zoneinfo/Asia/Tokyo'
end
# In order to config daemon auto start
package "sysv-rc-conf"
# restart cron. Somearticle said, "service crond restart", but crond has not been installed here, and below just works.
execute "Restart cron" do
  command 'service cron restart'
end

include_recipe 'belongsto::server'
include_recipe 'belongsto::apache'
# include_recipe 'belongsto::mysql'
# include_recipe 'belongsto::php'
# include_recipe 'belongsto::cakephp'
# include_recipe 'belongsto::shell'
