#
# Cookbook Name:: monit
# Recipe:: sshd
#

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

monit_check "sshd" do
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
