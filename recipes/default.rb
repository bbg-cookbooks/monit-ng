#
# Cookbook Name:: monit
# Recipe:: default
#

case node.monit.install_method
when 'repo'
  include_recipe "yum::epel" if platform_family?("rhel")
  package 'monit'
  include_recipe "monit::common"
when 'source'
  include_recipe "monit::source"
else
  raise ArgumentError, "Unknown valid '#{node.monit.install_method}' passed to monit cookbook"
end
