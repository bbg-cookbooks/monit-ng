#
# Cookbook Name: monit-ng
# Attributes: postfix
#

default['monit']['checks'].tap do |checks|
  checks['postfix'].tap do |postfix|
    postfix['pid'] = '/var/spool/postfix/pid/master.pid'
    case node['platform_family']
    when 'rhel'
      if node['platform_version'].to_f >= 7.0
        postfix['start'] = '/bin/systemctl start postfix.service'
        postfix['stop'] = '/bin/systemctl stop postfix.service'
      else
        postfix['start'] = '/etc/init.d/postfix start'
        postfix['stop'] = '/etc/init.d/postfix stop'
      end
    else
      postfix['start'] = '/etc/init.d/postfix start'
      postfix['stop'] = '/etc/init.d/postfix stop'
    end
  end
end
