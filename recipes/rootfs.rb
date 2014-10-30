#
# Cookbook name:: monit-ng
# Recipe:: rootfs
#

include_recipe cookbook_name

monit_check 'rootfs' do
  check_type 'filesystem'
  check_id '/'
  tests [
    {
      'condition' => 'space usage > 90%',
      'action' => 'alert',
    },
    {
      'condition' => 'inode usage > 90%',
      'action' => 'alert',
    },
    {
      'condition' => 'changed fsflags',
      'action' => 'alert',
    },
  ]
end
