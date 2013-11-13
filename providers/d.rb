def whyrun_supported?
  true
end

VALID_SERVICE_IDS = 
  {
    'process' => "pidfile",
    'procmatch' => "matching", 
    'file' => "path",
    'fifo' => "path",
    'filesystem' => "path",
    'directory' => "path",
    'host' => "address",
    'system' => nil,
    'program' => "path",
  }

def validate_rc!(f)
  cmd = Mixlib::ShellOut.new("monit -tc #{f}").run_command
  unless cmd.exitstatus == 0
    Chef::Log.error("rc validation failed!")
    Chef::Log.error(f.read)
    Chef::Application.fatal!("Template #{f} failed validation!")
    file f do
      action :delete
    end
  end
end

def render_rc
  rc_path = "#{node.monit.conf_dir}/#{new_resource.name}"

  t = template rc_path do
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
    action :nothing
    notifies :reload, "service[monit]", :delayed
  end

  t.run_action(:create)
  validate_rc!(rc_path)
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

action :install do
  render_rc
end

action :remove do
  f = file "#{node.monit.conf_dir}/#{new_resource.name}" do
    action :nothing
  end
  f.run_action(:delete)
  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
