#
# Cookbook Name: monit-ng
# Attributes: rsyslog
#

include_attribute 'monit-ng::default'

default['monit']['checks'].tap do |checks|
  checks['rsyslog'].tap do |rsyslog|
    rsyslog['pid'] = value_for_platform_family(
      'rhel'    => '/var/run/syslogd.pid',
      'debian'  => '/var/run/rsyslogd.pid',
      'default' => '/var/run/rsyslogd.pid',
    )

    case node['monit']['init_style']
    when 'systemd'
      rsyslog['start'] = '/bin/systemctl start rsyslog.service'
      rsyslog['stop'] = '/bin/systemctl stop rsyslog.service'
    when 'upstart'
      rsyslog['start'] = '/sbin/start rsyslog'
      rsyslog['stop'] = '/sbin/stop rsyslog'
    when 'sysv'
      rsyslog['start'] = '/etc/init.d/rsyslog start'
      rsyslog['stop'] = '/etc/init.d/rsyslog stop'
    end
  end
end
