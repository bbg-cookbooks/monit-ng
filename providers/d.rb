def whyrun_supported?
  true
end

def render_rc
  rc_path = "#{node['monit']['conf_dir']}/#{new_resource.name}.conf"

  template rc_path do
    cookbook 'monit'
    source 'monit.d.erb'
    cookbook 'monit'
    owner 'root'
    group 'root'
    mode '0600'
    variables :name => new_resource.name,
              :service_type => new_resource.service_type,
              :id_type => new_resource.service_type_id || VALID_SERVICE_IDS[new_resource.service_type],
              :service_id => new_resource.service_id,
              :service_group => new_resource.service_group,
              :start_command => new_resource.start_command,
              :start_as => new_resource.start_as,
              :stop_command => new_resource.stop_command,
              :service_tests => new_resource.service_tests,
              :every => new_resource.every
    action :create
    notifies :reload, "service[monit]", :delayed
  end
end

action :install do
  render_rc
  new_resource.updated_by_last_action(true)
end

action :remove do
  file "#{node['monit']['conf_dir']}/#{new_resource.name}" do
    action :delete
    notifies :reload, "service[monit]", :delayed
  end
  new_resource.updated_by_last_action(true)
end
