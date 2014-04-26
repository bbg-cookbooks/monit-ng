#
# Cookbook Name: monit
# Attributes: rsyslog
#

default['monit']['checks'].tap do |check|
  check['rsyslog_init'] = '/etc/init.d/rsyslog'
  check['rsyslog_pid'] = value_for_platform_family(
    'rhel'    => '/var/run/syslogd.pid',
    'debian'  => '/var/run/rsyslogd.pid',
    'default' => '/var/run/rsyslogd.pid',
  )
end
