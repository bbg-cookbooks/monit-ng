#
# Cookbook Name:: monit
# Recipe:: crond
#

crond_init = value_for_platform_family(
               'rhel'   => '/etc/init.d/crond',
               'debian' => '/etc/init.d/cron',
             )

monit_check 'crond' do
  check_id '/var/run/crond.pid'
  group 'system'
  start "#{crond_init} start"
  stop "#{crond_init} stop"
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
