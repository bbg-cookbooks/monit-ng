#
# Cookbook Name: monit-ng
# Attributes: sshd
#

include_attribute 'monit-ng::default'

default['monit']['checks'].tap do |checks|
  checks['sshd'].tap do |sshd|
    sshd['pid'] = '/var/run/sshd.pid'
    sshd['port'] = ((node['openssh'] || {})['server'] || {})['port'] || 22

    case node['monit']['init_style']
    when 'systemd'
      sshd['start'] = '/bin/systemctl start sshd.service'
      sshd['stop'] = '/bin/systemctl stop sshd.service'
    when 'upstart'
      sshd['start'] = '/sbin/start ssh'
      sshd['stop'] = '/sbin/stop ssh'
    when 'sysv'
      if platform_family?('rhel')
        sshd['start'] = '/etc/init.d/sshd start'
        sshd['stop'] = '/etc/init.d/sshd stop'
      else
        sshd['start'] = '/etc/init.d/ssh start'
        sshd['stop'] = '/etc/init.d/ssh stop'
      end
    end
  end
end
