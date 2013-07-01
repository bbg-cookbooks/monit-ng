VALID_SERVICE_IDS = 
  {
    'process' => "pidfile", 
    'file' => "path", 
    'fifo' => "path", 
    'filesystem' => "path", 
    'directory' => "path", 
    'host' => "address", 
    'system' => nil, 
    'program' => "path", 
  }

def validate_service!(f)
    cmd = Mixlib::Shellout.new("monit -tc #{f}").run_command
    unless cmd.exitstatus == 0
      Chef::Log.error("service failed validation: \n\n")
      Chef::Log.error("Removing service configuratino file #{f}")
      ::File.delete(f)
      Chef::Application.fatal!("Monit service #{f} failed validation.")
    end
end

action :install do
  f = "#{node.monit.conf_dir}/#{new_resource.name}"
  t = template "#{f}" do
    cookbook new_resource.cookbook
    source 'monit.d.erb'
    owner 'root'
    group 'root'
    mode '0600'
    variables({
      :name => new_resource.name,
      :service_type => new_resource.service_type,
      :id_type => VALID_SERVICE_IDS["#{new_resource.service_type}"],
      :service_id => new_resource.service_id,
      :service_group => new_resource.service_group,
      :start_command => new_resource.start_command,
      :stop_command => new_resource.stop_command,
      :service_tests => new_resource.service_tests
    })
    action :nothing
    notifies :reload, "service[monit]", :delayed
  end

  t.run_action(:create)
# a wild chef bug appears!
#  validate_service!("#{f}")

  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

action :delete do
  f = file "#{node.monit.conf_dir}/#{new_resource.name}" do
    action :nothing
  end
  f.run_action(:delete)
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end
