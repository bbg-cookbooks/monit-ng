#
# Cookbook Name:: monit-ng
# Recipe:: ntpd
#

ntpd = node['monit']['checks']['ntpd']

monit_check 'ntpd' do
  check_id ntpd['pid']
  start ntpd['start']
  stop ntpd['stop']
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
