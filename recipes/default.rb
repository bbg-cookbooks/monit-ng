#
# Cookbook Name:: monit-ng
# Recipe:: default
#

include_recipe "monit-ng::#{node['monit']['install_method']}"
include_recipe 'monit-ng::config' if node['monit']['configure']
