#
# Cookbook Name: monit-ng
# Attributes: default
#

default['monit'].tap do |monit|
  # one of: repo, source
  monit['install_method'] = 'repo'

  # should we setup the global config
  monit['configure'] = true

  # skip service management
  monit['skip_service'] = false

  # should we proactively scan the run_context in order to
  # reload if there are any altered monit_check resources?
  monit['proactive_reload'] = true

  # configuration file location
  monit['conf_file'] = value_for_platform_family(
    'rhel'    => '/etc/monit.conf',
    'debian'  => '/etc/monit/monitrc',
    'default' => '/etc/monitrc'
  )

  # includes directory (used by monit_check resource)
  monit['conf_dir'] = value_for_platform_family(
    'rhel'    => '/etc/monit.d',
    'debian'  => '/etc/monit/conf.d',
    'default' => '/etc/monit.d'
  )

  monit['init_style'] = value_for_platform(
    'debian' => {
      'default' => 'sysv',
      '>= 8' => 'systemd'
    },
    'ubuntu' => {
      'default' => 'upstart',
      '>= 14.10' => 'systemd'
    },
    %w(centos rhel) => {
      'default' => 'sysv',
      '>= 7.0' => 'systemd'
    }
  )
end
