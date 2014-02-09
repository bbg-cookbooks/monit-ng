#
# Cookbook Name: monit
# Provider:: check
#

def whyrun_supported?
  true
end

action :install do
  r = template 'monit-check' do
    cookbook new_resource.cookbook
    path "#{node['monit']['conf_dir']}/#{new_resource.name}.conf"
    source 'monit.check.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables(
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
    )
    action :create
  end

  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

action :uninstall do
  r = file "#{node['monit']['conf_dir']}/#{new_resource.name}.conf" do
    action :delete
    notifies :reload, 'service[monit]', :immediately
  end

  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
