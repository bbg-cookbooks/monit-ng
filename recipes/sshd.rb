#
# Cookbook Name:: monit
# Recipe:: sshd
#

sshd_pid = node['monit']['checks']['sshd_pid']
sshd_init = node['monit']['checks']['sshd_init']

ssh_port = node['monit']['checks']['sshd_port']

monit_check 'sshd' do
  check_id sshd_pid
  start "#{sshd_init} start"
  stop "#{sshd_init} stop"
  tests [
    {
      'condition' => "failed port #{ssh_port} proto ssh",
      'action'    => 'restart',
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
