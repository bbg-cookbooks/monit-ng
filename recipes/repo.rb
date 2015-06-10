#
# Cookbook Name:: monit-ng
# Recipe:: repo
#

# Monit is not in the default repositories
include_recipe 'yum-epel' if platform_family?('rhel') && !platform?('amazon')
include_recipe 'apt' if platform_family?('debian')
include_recipe 'ubuntu' if platform?('ubuntu')

package 'monit'

# If using syslog, remove hardcoded file logging from the package
if node['monit']['config']['log_file'] == 'syslog'
  file '/etc/monit.d/logging' do
    action :delete
  end

  file '/etc/logrotate.d/monit' do
    action :delete
  end

  directory '/var/log/monit' do
    action :delete
    recursive true
  end
end
