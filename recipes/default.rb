#
# Cookbook Name:: monit
# Recipe:: default
#

case node['monit']['install_method']
when 'repo'
  include_recipe 'monit::repo'
when 'source'
  include_recipe 'monit::source'
end

include_recipe 'monit::config' if node['monit']['configure']
