#
# Cookbook Name:: monit
# Recipe:: default
#

case node['monit']['install_method']
when 'repo'
  include_recipe 'monit-ng::repo'
when 'source'
  include_recipe 'monit-ng::source'
end

include_recipe 'monit-ng::config' if node['monit']['configure']
