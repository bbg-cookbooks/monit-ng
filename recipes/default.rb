#
# Cookbook Name:: monit
# Recipe:: default
#

case node['monit']['install_method']
when 'repo'
  if platform_family?("rhel")
    include_recipe "yum::epel"
  end
  include_recipe "ubuntu" if platform?("ubuntu")
  package 'monit'
  include_recipe "monit::_common"
when 'source'
  include_recipe "monit::source"
else
  raise ArgumentError, "Unknown install_method '#{node['monit']['install_method']}' passed to monit cookbook"
end
