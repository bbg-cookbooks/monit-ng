default['monit']['checks']['ntpd_pid'] = '/var/run/ntpd.pid'
default['monit']['checks']['ntpd_init'] = value_for_platform_family(
                                           'rhel'    => '/etc/init.d/ntpd',
                                           'debian'  => '/etc/init.d/ntp',
                                           'default' => '/etc/init.d/ntpd',
                                         )
