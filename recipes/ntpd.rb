#
# Cookbook Name:: monit
# Recipe:: ntpd
#

ntpd_init = value_for_platform_family(
              'rhel'   => '/etc/init.d/ntpd',
              'debian' => '/etc/init.d/ntp',
            )


monit_check 'ntpd' do
  check_id '/var/run/ntpd.pid'
  start "#{ntpd_init} start"
  stop "#{ntpd_init} stop"
  tests [
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
