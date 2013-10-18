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

# validate the resource by verifying
# against `monit -tc`
def validate_rc!(t)
  file = Tempfile.new('monitrc')

  begin
    file.write(capture(t))
    cmd = Mixlib::ShellOut.new("monit -tc #{file.path}").run_command
    unless cmd.exitstatus == 0
      Chef::Log.error("Monit watch file failed validation: \n\n")
      Chef::Log.error(file.read)
      Chef::Application.fatal!("Monit watch file '#{file.path}' failed validation!")
    end
  ensure
    file.close
    file.unlink
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
    notifies :reload, "service[monit]", :immediately
  end

  validate_rc!(t)

  t.run_action(:create)
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
