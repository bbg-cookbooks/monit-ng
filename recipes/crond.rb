#
# Cookbook Name:: monit
# Recipe:: crond
#

crond_pid = node['monit']['checks']['crond_pid']
crond_init = node['monit']['checks']['crond_init']

monit_check 'crond' do
  check_id crond_pid
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
