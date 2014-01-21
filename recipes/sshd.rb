#
# Cookbook Name:: monit
# Recipe:: sshd
#

sshd_init = value_for_platform_family(
              'rhel'   => '/etc/init.d/sshd',
              'debian' => '/etc/init.d/ssh',
            )

ssh_port = ((node['openssh'] || {})['server'] || {})['port'] || 22

monit_check 'sshd' do
  check_id '/var/run/sshd.pid'
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
