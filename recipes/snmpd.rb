#
# Cookbook Name:: monit
# Recipe:: snmpd
#

snmpd_pid = node['monit']['checks']['snmpd_pid']
snmpd_init = node['monit']['checks']['snmpd_init']

monit_check 'snmpd' do
  check_id snmpd_pid
  start "#{snmpd_init} start"
  stop "#{snmpd_init} stop"
  tests [
    {
      'condition' => 'failed port 161 type udp',
      'action'    => 'restart',
    },
    {
      'condition' => 'failed port 199 type tcp',
      'action'    => 'restart',
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
