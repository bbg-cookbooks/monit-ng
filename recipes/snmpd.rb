#
# Cookbook Name:: monit
# Recipe:: snmpd
#

monit_check 'snmpd' do
  check_id '/var/run/snmpd.pid'
  start '/etc/init.d/snmpd start'
  stop '/etc/init.d/snmpd stop'
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
