default['monit']['checks']['rsyslog_init'] = '/etc/init.d/rsyslog'
default['monit']['checks']['rsyslog_pid'] =
  value_for_platform_family(
    'rhel'    => '/var/run/syslogd.pid',
    'debian'  => '/var/run/rsyslogd.pid',
    'default' => '/var/run/rsyslogd.pid',
  )
