

include_recipe 'monit-ng'

monit_check node.name do
  check_type 'system'
  alert 'root@localhost'
  but_not_on true
  alert_events %w( instance )
end
