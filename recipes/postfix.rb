#
# Cookbook Name:: monit
# Recipe:: postfix
#

monit_check 'postfix' do
  check_id '/var/spool/postfix/pid/master.pid'
  group 'system'
  start '/etc/init.d/postfix start'
  stop  '/etc/init.d/postfix stop'
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
