#
# Cookbook Name:: monit-ng
# Recipe:: config
#

monit = node['monit']
config = monit['config']

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
  notifies :restart, 'service[monit]', :delayed
  only_if { platform_family?('debian') && ::File.exist?('/etc/default/monit') }
end

directory monit['conf_dir'] do
  owner 'root'
  group 'root'
  mode '0600'
  recursive true
  action :create
end

template monit['conf_file'] do # ~FC009
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
    :alert => config['alert'] || config['subscribers'],
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
  if Chef::VERSION.to_f >= 12
    verify do |path|
      "monit -tc #{path}"
    end
  end
  notifies :restart, 'service[monit]', :delayed
end

service 'monit' do
  if node['monit']['install_method'] == 'source'
    case node['monit']['init_style']
    when 'systemd'
      provider Chef::Provider::Service::Systemd
    when 'upstart'
      provider Chef::Provider::Service::Upstart
    end
  end
  action [:enable]
end

ruby_block 'conditional-monit-reload' do
  block do
    # Cherry-pick monit_check resources from the run_context
    checks = run_context.resource_collection.select do |r|
      r.is_a?(Chef::Resource::MonitCheck)
    end

    # Reload monit if any monit_check resources changed
    if checks.any?(&:updated_by_last_action?)
      resources(:service => 'monit').run_action(:reload)
    end
  end
  action :nothing
end

ruby_block 'notify-conditional-monit-reload' do
  block do
    Chef::Log.info('Notifying ruby_block[conditional-monit-reload] to run.')
  end
  notifies :run, 'ruby_block[conditional-monit-reload]', :delayed
  only_if { monit['proactive_reload'] }
end

ruby_block 'notify-start-monit' do
  block do
    Chef::Log.info('Notifying monit service to start.')
  end
  notifies :start, 'service[monit]', :delayed
end
