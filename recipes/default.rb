#
# Cookbook Name:: monit
# Recipe:: default
#

case node['monit']['install_method']
when 'repo'
  include_recipe "monit::repo"
when 'source'
  include_recipe "monit::source"
else
  raise ArgumentError, "Unknown install_method passed to cookbook: #{node['monit']['install_method']}"
end
