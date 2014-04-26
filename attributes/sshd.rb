#
# Cookbook Name: monit
# Attributes: sshd
#

default['monit']['checks'].tap do |check|
  check['sshd_pid'] = '/var/run/sshd.pid'
  check['sshd_port'] = ((node['openssh'] || {})['server'] || {})['port'] || 22
  check['sshd_init'] = value_for_platform_family(
     'rhel'    => '/etc/init.d/sshd',
     'debian'  => '/etc/init.d/ssh',
     'default' => '/etc/init.d/sshd',
   )
end
