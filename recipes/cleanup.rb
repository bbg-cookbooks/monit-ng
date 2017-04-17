#
# Cookbook Name:: monit-ng
# Recipe:: cleanup
#

ruby_block 'conditional-monit-cleanup' do
  block do
    checks = run_context.resource_collection.select {|r| r.is_a?(Chef::Resource::MonitCheck) }.collect {|d| d.name}

    Dir.glob(File.join(node['monit']['conf_dir'], "*.conf")).each do |conf|
      unless checks.include?(File.basename(conf).gsub(/\.conf/,''))
        cb_file = Chef::Resource::File.new conf, run_context
        cb_file.run_action(:delete)
      end
    end
  end

  action :nothing
end

ruby_block 'notify-conditional-monit-cleanup' do
  block do
    Chef::Log.info('Notifying ruby_block[conditional-monit-cleanup] to run.')
  end
  notifies :run, 'ruby_block[conditional-monit-cleanup]', :delayed
  only_if { node['monit']['do_cleanup'] }
  action :run
end
