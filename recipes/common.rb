#
# Author:: Nathan Williams <nath.e.will@gmail.com>
# Cookbook Name:: monit
# Recipe:: common
#

case node.monit.install_method
when 'repo'
  control_file = "#{node.monit.conf_file}"
when 'source'
 control_file = "/etc/monitrc"
else
  raise ArgumentError, "Unknown valid '#{node.monit.install_method}' passed to monit cookbook"
end

service "monit" do
  service_name "monit"
  supports :status => true, :restart => true, :reload => true, :stop => true
  action [ :enable, :start ]
end

template control_file do
  source 'monit.conf.erb'
  owner 'root'
  mode '0600'
  variables({
    :daemon => node.monit.config.poll_freq,
    :start_delay => node.monit.config.start_delay,
    :log_file => node.monit.config.log_file,
    :id_file => node.monit.config.id_file,
    :state_file => node.monit.config.state_file,
    :mailservers => node.monit.config.mailservers,
    :subscribers => node.monit.config.subscribers,
    :eventqueue_dir => node.monit.config.eventqueue_dir,
    :eventqueue_slots => node.monit.config.eventqueue_slots,
    :address => node.monit.config.listen_addr,
    :port => node.monit.config.listen_port,
    :allow => node.monit.config.listen_allow,
    :mail_from => node.monit.config.mail_from,
    :mail_subject => node.monit.config.mail_subject,
    :mail_msg => node.monit.config.mail_message,
    :mmonit => node.monit.config.mmonit_host,
    :conf_dir => node.monit.conf_dir,
  })
  notifies :reload, "service[monit]", :immediately
end
