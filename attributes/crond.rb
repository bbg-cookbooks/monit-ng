#
# Cookbook Name: monit-ng
# Attributes: crond
#

include_attribute 'monit-ng::default'

default['monit']['checks'].tap do |checks|
  checks['crond'].tap do |crond|
    crond['pid'] = '/var/run/crond.pid'

    case node['monit']['init_style']
    when 'systemd'
      crond['start'] = '/bin/systemctl start crond.service'
      crond['stop'] = '/bin/systemctl stop crond.service'
    when 'upstart'
      crond['start'] = '/sbin/start cron'
      crond['stop'] = '/sbin/stop cron'
    when 'sysv'
      if platform_family?('rhel')
        crond['start'] = '/etc/init.d/crond start'
        crond['stop'] = '/etc/init.d/crond stop'
      else
        crond['start'] = '/etc/init.d/cron start'
        crond['stop'] = '/etc/init.d/cron stop'
      end
    end
  end
end
