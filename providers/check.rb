def whyrun_supported?
  true
end

def render_rc
  monit_check = "#{node['monit']['conf_dir']}/#{new_resource.name}.conf"

  template monit_check do
    cookbook new_resource.cookbook
    source 'monit.d.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables({ 
      :name => new_resource.name,
      :check_type => new_resource.check_type,
      :id_type => new_resource.id_type,
      :check_id => new_resource.check_id,
      :group => new_resource.group,
      :start => new_resource.start,
      :start_as => new_resource.start_as,
      :stop => new_resource.stop,
      :tests => new_resource.tests,
      :every => new_resource.every,
    })
    action :create
    notifies :reload, "service[monit]", :delayed
  end
end

action :install do
  render_rc
  new_resource.updated_by_last_action(true)
end

action :remove do
  file "#{node['monit']['conf_dir']}/#{new_resource.name}.conf" do
    action :delete
    notifies :reload, "service[monit]", :delayed
  end
  new_resource.updated_by_last_action(true)
end
