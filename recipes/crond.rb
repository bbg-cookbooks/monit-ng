#
# Cookbook Name:: monit-ng
# Recipe:: crond
#

include_recipe cookbook_name

crond = node['monit']['checks']['crond']

monit_check 'crond' do
  check_id crond['pid']
  group 'system'
  start crond['start']
  stop crond['stop']
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
