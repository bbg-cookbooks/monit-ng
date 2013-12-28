#
# Cookbook Name:: monit
# Recipe:: default
#

case node['monit']['install_method']
when 'repo'
  include_recipe "monit::repo"
when 'source'
  include_recipe "monit::source"
else
  raise ArgumentError, "Unknown install_method passed to cookbook: #{node['monit']['install_method']}"
end

include_recipe "monit::config"

monit_d "sshd" do
  check_id sshd_pid
  start sshd_start
  stop sshd_stop
  tests [
    {
      'condition' => "failed port 22 proto ssh",
      'action'    => "restart"
    },
    {
      'condition' => "3 restarts within 5 cycles",
      'action'    => "alert"
    },
  ]
end
