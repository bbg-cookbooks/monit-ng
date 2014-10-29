#
# Cookbook Name: monit-ng
# Attributes: sshd
#

default['monit']['checks'].tap do |checks|
  checks['sshd'].tap do |sshd|
    sshd['pid'] = '/var/run/sshd.pid'
    sshd['port'] = ((node['openssh'] || {})['server'] || {})['port'] || 22
    case node['platform_family']
    when 'rhel'
      if node['platform_version'].to_f >= 7.0
        sshd['start'] = '/bin/systemctl start sshd.service'
        sshd['stop'] = '/bin/systemctl stop sshd.service'
      else
        sshd['start'] = '/etc/init.d/sshd start'
        sshd['stop'] = '/etc/init.d/sshd stop'
      end
    else
      sshd['start'] = '/etc/init.d/ssh start'
      sshd['stop'] = '/etc/init.d/ssh stop'
    end
  end
end
