#
# Cookbook Name: monit-ng
# Attributes: default
#

default['monit'].tap do |monit|

  # one of: repo, source
  monit['install_method'] = 'repo'

  # should we setup the global config
  monit['configure'] = true

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
