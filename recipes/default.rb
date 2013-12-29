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

case node['platform_family']
when "rhel"
  sshd_pid = "/var/run/sshd.pid"
  sshd_start = "service sshd start"
  sshd_stop = "service sshd stop"
when "debian"
  sshd_pid = "/var/run/sshd.pid"
  sshd_start = "service ssh start"
  sshd_stop = "service ssh stop"
else
  sshd_pid = "/var/run/sshd.pid"
  sshd_start = "/etc/init.d/sshd start"
  sshd_stop = "/etc/init.d/sshd stop"
end

monit_d "sshd" do
  check_id sshd_pid
  start sshd_start
  stop sshd_stop
  tests [
    {
      'condition' => "3 restarts within 5 cycles",
      'action'    => "alert"
    },
  ]
end
