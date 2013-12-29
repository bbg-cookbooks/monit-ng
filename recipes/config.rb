#
# Cookbook Name:: monit
# Recipe:: config
#

monit = node['monit']
config = monit['config']

directory 'include_dir' do
  path monit['conf_dir']
  owner 'root'
  group 'root'
  mode '0600'
  recursive true
  action :create
end

template '/etc/default/monit' do
  source 'monit.default.erb'
  owner 'root'
  group 'root'
  mode '0600'
  only_if { platform?("ubuntu") && node['platform_version'] =~ /^10/ }
end

template monit['conf_file'] do
  source 'monit.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables({
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
  })
  notifies :reload, "service[monit]", :delayed
end

service 'monit' do
  service_name "monit"
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
