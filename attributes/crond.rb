default['monit']['checks']['crond_pid'] = '/var/run/crond.pid'
default['monit']['checks']['crond_init'] = value_for_platform_family(
                                             'rhel'    => '/etc/init.d/crond',
                                             'debian'  => '/etc/init.d/cron',
                                             'default' => '/etc/init.d/crond',
                                           )
