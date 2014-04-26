#
# Cookbook Name: monit
# Attributes: config
#

include_attribute 'monit::default'

default['monit']['config'].tap do |conf|
  conf['mmonit_url'] = nil

  conf['poll_freq'] = 60
  conf['start_delay'] = 5

  conf['eventqueue_dir'] = '/var/tmp'
  conf['eventqueue_slots'] = 100
  conf['log_file'] = '/var/log/monit.log'
  conf['id_file'] = '/var/lib/monit.id'
  conf['state_file'] = '/var/run/monit.state'

  conf['subscribers'] = [
    {
      'name'          => 'root@localhost',
      'subscriptions' => %w( nonexist timeout resource icmp connection ),
    },
  ]

  conf['port'] = 2812
  conf['listen'] = '127.0.0.1'

  conf['allow'] = ['localhost']

  conf['mail_from'] = "monit@#{node['fqdn']}"
  conf['mail_subject'] = '$SERVICE $EVENT at $DATE'
  conf['mail_message'] = <<-EOT
    Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
    Yours sincerely,
    monit
  EOT
  conf['mail_servers'] = [
    {
      :hostname => 'localhost',
      :port => 25,
      :username => nil,
      :password => nil,
      :security => nil,
      :timeout => '30 seconds',
    },
  ]
end
