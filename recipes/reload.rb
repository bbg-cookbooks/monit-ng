#
# Cookbook Name:: monit-ng
# Recipe:: reload
#

ruby_block 'conditional-monit-reload' do
  block do
    # Cherry-pick monit_check resources from the run_context
    checks = run_context.resource_collection.select do |r|
      r.is_a?(Chef::Resource::MonitCheck)
    end

    # Reload monit if any monit_check resources changed
    if checks.any?(&:updated_by_last_action?)
      Chef::Log.info('Found updated monit checks, issuing service reload.')
      resources(service: 'monit').run_action(:reload)
    end
  end
  action :nothing
end

# Notify the resource scanning/proactive reload block
# to run at the end of the converge cycle
ruby_block 'notify-conditional-monit-reload' do
  block do
    Chef::Log.info('Notifying ruby_block[conditional-monit-reload] to run.')
  end
  notifies :run, 'ruby_block[conditional-monit-reload]', :delayed
  only_if { node['monit']['proactive_reload'] }
  action :run
end
