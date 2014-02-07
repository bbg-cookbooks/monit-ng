#
# Cookbook Name:: monit
# Recipe:: ntpd
#

ntpd_pid = node['monit']['checks']['ntpd_pid']
ntpd_init = node['monit']['checks']['ntpd_init']

monit_check 'ntpd' do
  check_id ntpd_pid
  start "#{ntpd_init} start"
  stop "#{ntpd_init} stop"
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
