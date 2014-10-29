#
# Cookbook Name: monit-ng
# Attributes: ntpd
#

default['monit']['checks'].tap do |checks|
  checks['ntpd'].tap do |ntpd|
    ntpd['pid'] = '/var/run/ntpd.pid'
    case platform_family
    when 'rhel'
      if node['platform_version'].to_f >= 7.0
        ntpd['start'] = '/bin/systemctl start ntpd.service'
        ntpd['stop'] = '/bin/systemctl stop ntpd.service'
      else
        ntpd['start'] = '/etc/init.d/ntpd start'
        ntpd['stop'] = '/etc/init.d/ntpd stop'
      end
    else
      ntpd['start'] = '/etc/init.d/ntp start'
      ntpd['stop'] = '/etc/init.d/ntp stop'
    end
  end
end
