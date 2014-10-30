#
# Cookbook Name:: monit-ng
# Recipe:: sshd
#

include_recipe cookbook_name

sshd = node['monit']['checks']['sshd']

monit_check 'sshd' do
  check_id sshd['pid']
  start sshd['start']
  stop sshd['stop']
  tests [
    {
      'condition' => "failed port #{sshd['port']} proto ssh",
      'action'    => 'restart',
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'unmonitor',
    },
  ]
end
