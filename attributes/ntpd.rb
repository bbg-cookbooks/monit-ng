#
# Cookbook Name: monit-ng
# Attributes: ntpd
#

include_attribute 'monit-ng::default'

default['monit']['checks'].tap do |checks|
  checks['ntpd'].tap do |ntpd|
    ntpd['pid'] = '/var/run/ntpd.pid'

    case node['monit']['init_style']
    when 'systemd'
      ntpd['start'] = '/bin/systemctl start ntpd.service'
      ntpd['stop'] = '/bin/systemctl stop ntpd.service'
    when 'upstart'
      ntpd['start'] = '/sbin/start ntp'
      ntpd['stop'] = '/sbin/stop ntp'
    when 'sysv'
      if platform_family?('rhel')
        ntpd['start'] = '/etc/init.d/ntpd start'
        ntpd['stop'] = '/etc/init.d/ntpd stop'
      else
        ntpd['start'] = '/etc/init.d/ntp start'
        ntpd['stop'] = '/etc/init.d/ntp stop'
      end
    end
  end
end
