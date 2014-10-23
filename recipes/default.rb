#
# Cookbook Name:: monit-ng
# Recipe:: default
#

include_recipe "#{cookbook_name}::#{node['monit']['install_method']}"
include_recipe "#{cookbook_name}::config" if node['monit']['configure']
