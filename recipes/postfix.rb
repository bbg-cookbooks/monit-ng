#
# Cookbook Name:: monit
# Recipe:: postfix
#

postfix_pid = node['monit']['checks']['postfix_pid']
postfix_init = node['monit']['checks']['postfix_init']

monit_check 'postfix' do
  check_id postfix_pid
  group 'system'
  start "#{postfix_init} start"
  stop  "#{postfix_init} stop"
  tests [
    {
      'condition' => 'failed port 25 proto smtp 2 times within 3 cycles',
      'action'    => 'restart',
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
