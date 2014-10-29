#
# Cookbook Name: monit-ng
# Attributes: default
#

default['monit'].tap do |monit|

  # one of: repo, source
  monit['install_method'] = 'repo'

  # should we setup the global config
  monit['configure'] = true

  # configure default service_provider
  monit['svc_provider'] = case monit['install_method']
                          when 'repo'
                            Chef::Platform.find_provider_for_node(
                              node, :service
                            )
                          when 'source'
                            if platform_family?('rhel') &&
                               node['platform_version'].to_f >= 7.0
                              Chef::Provider::Service::Systemd
                            elsif platform?('ubuntu') &&
                                  node['platform_version'].to_f >= 12.04
                              Chef::Provider::Service::Upstart
                            else
                              Chef::Platform.find_provider_for_node(
                                node, :service
                              )
                            end
                          end

  # configuration file location
  monit['conf_file'] = value_for_platform_family(
    'rhel'    => '/etc/monit.conf',
    'debian'  => '/etc/monit/monitrc',
    'default' => '/etc/monitrc',
  )

  # includes directory (used by monit_check resource)
  monit['conf_dir'] = value_for_platform_family(
    'rhel'    => '/etc/monit.d',
    'debian'  => '/etc/monit/conf.d',
    'default' => '/etc/monit.d',
  )
end
