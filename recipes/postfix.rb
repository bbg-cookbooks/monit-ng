#
# Cookbook Name:: monit-ng
# Recipe:: postfix
#

include_recipe cookbook_name

postfix = node['monit']['checks']['postfix']

monit_check 'postfix' do
  check_id postfix['pid']
  group 'system'
  start postfix['start']
  stop postfix['stop']
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
