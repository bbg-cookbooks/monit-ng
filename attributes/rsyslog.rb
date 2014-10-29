#
# Cookbook Name: monit-ng
# Attributes: rsyslog
#

default['monit']['checks'].tap do |checks|
  checks['rsyslog'].tap do |rsyslog|
    rsyslog['pid'] = value_for_platform_family(
      'rhel'    => '/var/run/syslogd.pid',
      'debian'  => '/var/run/rsyslogd.pid',
      'default' => '/var/run/rsyslogd.pid',
    )
    case node['platform_family']
    when 'rhel'
      if node['platform_version'].to_f >= 7.0
        rsyslog['start'] = '/bin/systemctl start rsyslog.service'
        rsyslog['stop'] = '/bin/systemctl stop rsyslog.service'
      else
        rsyslog['start'] = '/etc/init.d/rsyslog start'
        rsyslog['stop'] = '/etc/init.d/rsyslog stop'
      end
    else
      rsyslog['start'] = '/etc/init.d/rsyslog start'
      rsyslog['stop'] = '/etc/init.d/rsyslog stop'
    end
  end
end
