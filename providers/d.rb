VALID_SERVICE_TYPES = 
  {
    :process => {:id_type => "pidfile", 
                 :tests   => ["exists", 
                              "resource", 
                              "pid", 
                              "ppid", 
                              "uptime", 
                              "connection"],
                },
    :file => {:id_type => "path", 
              :tests   => ["exists", 
                           "checksum", 
                           "timestamp", 
                           "size", 
                           "content", 
                           "permission", 
                           "uid", 
                           "gid"],
             },

    :fifo => {:id_type => "path", 
              :tests   => ["timestamp", 
                           "permission", 
                           "uid", 
                           "gid"],
             },

    :filesystem => {:id_type => "path", 
                    :tests   => ["flags", 
                                 "space", 
                                 "inode", 
                                 "permission", 
                                 "uid", 
                                 "gid"],
                   },

    :directory => {:id_type => "path", 
                   :tests   => ["timestamp", 
                                "permission", 
                                "uid", 
                                "gid"],
                  },

    :host => {:id_type => "address", 
              :tests   => ["connection"],
             },

    :system => {:id_type => nil, 
                :tests   => ["resource"],
               },

    :program => {:id_type => "path", 
                 :tests   => ["status"],
                },
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
    mode '0600'
    variables({
      :name => new_resource.name,
      :service_type => new_resource.service_type,
      :id_type => "pidfile",
      :service_id => new_resource.service_id,
      :service_group => new_resource.service_group,
      :start_command => new_resource.start_command,
      :stop_command => new_resource.start_command,
      :service_tests => new_resource.service_tests
    })
    action :nothing
  end

#  validate_service!(t)

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

private
def capture(template)
  context = {}
  context.merge!(template.variables)
  context[:node] = node

  eruby = Erubis::Eruby.new(::File.read(template.source))
  return eruby.evaluate(context)
end
