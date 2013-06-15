
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

def validate_service!(resource)
  f = Tempfile.new('monit_service')
  begin
    f.write(capture(resource))
    cmd = Mixlib::Shellout.new("monit -tc #{f.path}").run_command
    unless cmd.exitstatus == 0
      Chef::Log.error("service failed validation: \n\n")
      Chef::Log.error(f.read)
      Chef::Application.fatal!("Monit service #{f.path} failed validation.")
    end
  ensure
    f.close
    f.unlink
  end
end

action :install do
  t = template "#{node.monit.conf_dir}/#{new_resource.name}" do
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
      :stop_command => new_resource.start_command,
      :service_tests => new_resource.service_tests
    })
    action :nothing
    notifies :reload, "service[monit]", :delayed
  end

  validate_service!(t)

  t.run_action(:create)
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

action :delete do
  f = file "#{node.monit.conf_dir}/#{new_resource.name}" do
    action :nothing
  end
  f.run_action(:delete)
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

# shamelessly lifted from the sudo cookbook
private
def capture(template)
  context = {}
  context.merge!(template.variables)
  context[:node] = node

  eruby = Erubis::Eruby.new(::File.read(template_location(template)))
  return eruby.evaluate(context)
end

def template_location(template)
  if template.local
    template.source
  else
    context = template.instance_variable_get('@run_context')
    cookbook = context.cookbook_collection[template.cookbook || template.cookbook_name]
    cookbook.preferred_filename_on_disk_location(node, :templates, template.source)
  end
end
