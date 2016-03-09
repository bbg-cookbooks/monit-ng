#
# Cookbook Name:: monit-ng
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

template monit['conf_file'] do # ~FC009
  source 'monit.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    poll_freq: config['poll_freq'],
    start_delay: config['start_delay'],
    log_file: config['log_file'],
    id_file: config['id_file'],
    state_file: config['state_file'],
    pid_file: config['pid_file'],
    mail_servers: config['mail_servers'],
    alert: config['alert'] || config['subscribers'],
    eventqueue_dir: config['eventqueue_dir'],
    eventqueue_slots: config['eventqueue_slots'],
    listen: config['listen'],
    port: config['port'],
    allow: config['allow'],
    mail_from: config['mail_from'],
    mail_subject: config['mail_subject'],
    mail_msg: config['mail_message'],
    mmonit_url: config['mmonit_url'],
    conf_dir: monit['conf_dir'],
    built_in_config_path: config['built_in_config_path'],
    built_in_configs: config['built_in_configs']
  )
  if Chef::VERSION.to_f >= 12
    verify do |path|
      "monit -tc #{path}"
    end
  end
end
