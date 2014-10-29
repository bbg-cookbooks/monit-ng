#
# Cookbook Name: monit-ng
# Attributes: crond
#

default['monit']['checks'].tap do |checks|
  checks['crond'].tap do |crond|
    crond['pid'] = '/var/run/crond.pid'
    case platform_family
    when 'rhel'
      if node['platform_version'].to_f >= 7.0
        crond['start'] = '/bin/systemctl start crond.service'
        crond['stop'] = '/bin/systemctl stop crond.service'
      else
        crond['start'] = '/etc/init.d/crond start'
        crond['stop'] = '/etc/init.d/crond stop'
      end
    else
      crond['start'] = '/etc/init.d/cron start'
      crond['stop'] = '/etc/init.d/cron stop'
    end
  end
end
