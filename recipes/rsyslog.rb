#
# Cookbook Name:: monit
# Recipe:: rsyslog
#

rsyslog_pid = node['monit']['checks']['rsyslog_pid']
rsyslog_init = node['monit']['checks']['rsyslog_init']

monit_check 'rsyslog' do
  check_id rsyslog_pid
  group 'system'
  start "#{rsyslog_init} start"
  stop "#{rsyslog_init} stop"
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
