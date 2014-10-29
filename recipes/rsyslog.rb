#
# Cookbook Name:: monit-ng
# Recipe:: rsyslog
#

rsyslog = node['monit']['checks']['rsyslog']

monit_check 'rsyslog' do
  check_id rsyslog['pid']
  group 'system'
  start rsyslog['start']
  stop rsyslog['stop']
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
