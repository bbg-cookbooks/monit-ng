#
# Cookbook Name: monit-ng
# Attributes: crond
#

default['monit']['checks'].tap do |check|
  check['crond_pid'] = '/var/run/crond.pid'
  check['crond_init'] = value_for_platform_family(
    'rhel'    => '/etc/init.d/crond',
    'debian'  => '/etc/init.d/cron',
    'default' => '/etc/init.d/crond',
  )
end
