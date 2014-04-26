#
# Cookbook Name: monit
# Attributes: snmpd
#

default['monit']['checks'].tap do |check|
  check['snmpd_pid'] = '/var/run/snmpd.pid'
  check['snmpd_init'] = '/etc/init.d/snmpd'
end
