#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Translated Instructions From:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis
#

execute "apt-get update"

package "build-essential"

package "tcl8.5"

version_number = node['redis']['version']

# download http://download.redis.io/releases/redis-2.8.9.tar.gz
remote_file "/tmp/redis-#{version_number}.tar.gz" do
  source "http://download.redis.io/releases/redis-#{version_number}.tar.gz"
  notifies :run, "execute[unzip_redis_archive]", :immediately
end

# unzip the archive
execute 'unzip_redis_archive' do
  command "tar xzf /tmp/redis-#{version_number}.tar.gz"
  cwd "/tmp"
  action :nothing
  notifies :run, "execute[redis_build_and_install]", :immediately
end

# Configure the application: make and make install
execute "redis_build_and_install" do
  cwd "/tmp/redis-#{version_number}"
  action :nothing
  notifies :run, "execute[echo -n | ./install_server.sh]", :immediately
end

# Install the Server
execute "echo -n | ./install_server.sh" do
  cwd "/tmp/redis-#{version_number}/utils"
  action :nothing
end

service "redis_6379" do
  action [:start]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
