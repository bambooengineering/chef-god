#
# Cookbook Name:: god
# Recipe:: default
#

rbenv_gem 'god'

group 'god' do
  action :create
  members node[:god][:users]
end

file '/etc/sudoers.d/god' do
  action :create
  mode '0440'
  owner 'root'
  group 'root'
  content <<EOF
Cmnd_Alias GOD = /usr/local/rbenv/shims/god *
%god ALL = NOPASSWD: GOD
EOF
end

template '/etc/god.conf' do
    action :create
    mode '0440'
    owner 'root'
    group 'root'
    source 'god.conf.erb'
end

template '/etc/init.d/god' do
  source 'god.init.erb'
  action :create
  mode '0755'
  owner 'root'
  group 'root'
  variables(
    :default_ruby => node[:rbenv][:global]
  )
end

service 'god' do
  action :enable
end
