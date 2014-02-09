default['monit']['checks']['sshd_pid'] = '/var/run/sshd.pid'
default['monit']['checks']['sshd_port'] =
  ((node['openssh'] || {})['server'] || {})['port'] || 22
default['monit']['checks']['sshd_init'] = value_for_platform_family(
                                            'rhel'    => '/etc/init.d/sshd',
                                            'debian'  => '/etc/init.d/ssh',
                                            'default' => '/etc/init.d/sshd',
                                          )
