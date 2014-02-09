#
# Cookbook Name:: monit
# Recipe:: config
#

monit = node['monit']
config = monit['config']

directory monit['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0600'
  recursive true
  action :create
end

# Exists in older Debian/Ubuntu platforms
# and disables monit starting by default
# despite being enabled in appropriate run-levels
template '/etc/default/monit' do
  source 'monit.default.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :platform         => node['platform'],
    :platform_version => node['platform_version'],
  )
  only_if { platform_family?('debian') && ::File.exist?('/etc/default/monit') }
end

template monit['conf_file'] do
  source 'monit.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    :poll_freq => config['poll_freq'],
    :start_delay => config['start_delay'],
    :log_file => config['log_file'],
    :id_file => config['id_file'],
    :state_file => config['state_file'],
    :mail_servers => config['mail_servers'],
    :subscribers => config['subscribers'],
    :eventqueue_dir => config['eventqueue_dir'],
    :eventqueue_slots => config['eventqueue_slots'],
    :listen => config['listen'],
    :port => config['port'],
    :allow => config['allow'],
    :mail_from => config['mail_from'],
    :mail_subject => config['mail_subject'],
    :mail_msg => config['mail_message'],
    :mmonit_url => config['mmonit_url'],
    :conf_dir => monit['conf_dir'],
  )
  notifies :restart, 'service[monit]', :immediately
end

service 'monit' do
  case monit['install_method']
  when 'source'
    status_command '/etc/init.d/monit status | grep -q uptime'
    supports :reload => true, :status => true, :restart => true
  when 'repo'
    if platform_family?('debian') && ::File.exist?('/etc/default/monit')
      subscribes :restart, 'template[/etc/default/monit]', :immediately
    else
      supports :reload => true, :status => true, :restart => true
    end
  end
  subscribes :restart, 'template[monit-check]', :immediately
  action [:enable, :start]
end
