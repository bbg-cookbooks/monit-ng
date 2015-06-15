#
# Cookbook Name:: monit-ng
# Recipe:: service
#

# Enable the service
service 'monit' do
  action [:enable]
end

# Start the service at the end so we can clean up/repair
# any broken monit configuration before attempting
ruby_block 'notify-start-monit' do
  block do
    Chef::Log.info('Notifying monit service to start.')
  end
  notifies :start, 'service[monit]', :delayed
end
