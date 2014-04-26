#
# Cookbook Name: monit
# Attributes: postfix
#

default['monit']['checks'].tap do |check|
  check['postfix_pid'] = '/var/spool/postfix/pid/master.pid'
  check['postfix_init'] = '/etc/init.d/postfix'
end
