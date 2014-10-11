#
# Cookbook Name: monit-ng
# Attributes: ntpd
#

default['monit']['checks'].tap do |check|
  check['ntpd_pid'] = '/var/run/ntpd.pid'
  check['ntpd_init'] = value_for_platform_family(
    'rhel'    => '/etc/init.d/ntpd',
    'debian'  => '/etc/init.d/ntp',
    'default' => '/etc/init.d/ntpd',
  )
end
