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

service "monit" do
  service_name "monit"
  supports :status => true, :restart => true, :reload => true, :stop => true
  action [ :enable, :start ]
end

include_recipe "monit::config"
