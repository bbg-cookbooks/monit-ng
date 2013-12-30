#
# Cookbook Name:: monit
# Recipe:: sshd
#

case node['platform_family']
when 'rhel'
  sshd_pid = '/var/run/sshd.pid'
  sshd_start = '/etc/init.d/sshd start'
  sshd_stop = '/etc/init.d/sshd stop'
when 'debian'
  sshd_pid = '/var/run/sshd.pid'
  sshd_start = '/etc/init.d/ssh start'
  sshd_stop = '/etc/init.d/ssh stop'
else
  sshd_pid = '/var/run/sshd.pid'
  sshd_start = '/etc/init.d/sshd start'
  sshd_stop = '/etc/init.d/sshd stop'
end

ssh_port = ((node['openssh'] || {})['server'] || {})['port'] || 22

monit_check 'sshd' do
  check_id sshd_pid
  start sshd_start
  stop sshd_stop
  tests [
    {
      'condition' => "failed port #{ssh_port} proto ssh",
      'action' => 'restart'
    },
  ]
end
