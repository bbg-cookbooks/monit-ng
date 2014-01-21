#
# Cookbook Name:: monit
# Recipe:: rsyslog
#

rsyslog_pid = value_for_platform_family(
                'rhel'   => '/var/run/syslogd.pid',
                'debian' => '/var/run/rsyslogd.pid',
              )

monit_check 'rsyslog' do
  check_id rsyslog_pid
  group 'system'
  start '/etc/init.d/rsyslog start'
  stop '/etc/init.d/rsyslog stop'
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
