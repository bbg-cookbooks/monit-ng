#
# Cookbook Name: monit-ng
# Attributes: config
#

include_attribute 'monit-ng::default'

default['monit']['config'].tap do |conf|
  # have monit report to M/Monit
  conf['mmonit_url'] = nil

  # How often should monit poll
  conf['poll_freq'] = 60

  # configure a delay before beginning polling
  # allows for normal system startup
  conf['start_delay'] = 5

  # where to queue events if mail server unavailable
  conf['eventqueue_dir'] = '/var/tmp'

  # how large a backlog of events to maintain
  conf['eventqueue_slots'] = 100

  # log path
  conf['log_file'] = '/var/log/monit.log'

  # where to store mmonit system id file
  conf['id_file'] = '/var/lib/monit.id'

  # where to save state between startups
  conf['state_file'] = '/var/run/monit.state'

  # where to save pid of current process
  conf['pid_file'] = '/var/run/monit.pid'

  # list of subscribers to all alerts
  conf['subscribers'] = []

  # what port to bind to
  conf['port'] = 2812

  # what interface to bind to
  # binding to a public interface
  # will make the web ui accessible
  conf['listen'] = '127.0.0.1'

  # list of permitted control port accessors (host, basic-auth, pam, htpasswd)
  conf['allow'] = ['localhost']

  # mail system configuration
  conf['mail_from'] = "monit@#{node['fqdn'] || 'localhost'}"
  conf['mail_subject'] = '$SERVICE $EVENT at $DATE'
  conf['mail_message'] = <<-EOT
    Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
    Yours sincerely,
    monit
  EOT
  conf['mail_servers'] = []

  # monit built-in configuration files path
  conf['built_in_config_path'] = '/etc/monit/monitrc.d'

  # what built-in configurations to load
  conf['built_in_configs'] = []
end
