#
# Cookbook Name: monit-ng
# Attributes: postfix
#

include_attribute 'monit-ng::default'

default['monit']['checks'].tap do |checks|
  checks['postfix'].tap do |postfix|
    postfix['pid'] = '/var/spool/postfix/pid/master.pid'

    case node['monit']['init_style']
    when 'systemd'
      postfix['start'] = '/bin/systemctl start postfix.service'
      postfix['stop'] = '/bin/systemctl stop postfix.service'
    when 'upstart'
      postfix['start'] = '/sbin/start postfix'
      postfix['stop'] = '/sbin/stop postfix'
    when 'sysv'
      postfix['start'] = '/etc/init.d/postfix start'
      postfix['stop'] = '/etc/init.d/postfix stop'
    end
  end
end
