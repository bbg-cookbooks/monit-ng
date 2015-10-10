#
# Cookbook Name:: monit-ng
# Recipe:: service
#

# Exists in older Debian/Ubuntu platforms
# and disables monit starting by default
# despite being enabled in appropriate run-levels
template '/etc/default/monit' do
  source 'monit.default.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    platform: node['platform'],
    platform_version: node['platform_version']
  )
  action :create
  only_if do
    platform_family?('debian') &&
      ::File.exist?('/etc/default/monit')
  end
end

# Enable the service
service 'monit' do
  action [:enable]
  subscribes :restart, "template[#{node['monit']['conf_file']}]", :delayed
  subscribes :restart, 'template[/etc/default/monit]', :delayed
  not_if { node['monit']['skip_service'] }
end

# Start the service at the end so we can clean up/repair
# any broken monit configuration before attempting
ruby_block 'notify-start-monit' do
  block do
    Chef::Log.info('Notifying monit service to start.')
  end
  notifies :start, 'service[monit]', :delayed
  action :run
end
