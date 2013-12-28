

include_attribute "monit::default"

default['monit']['config']['mmonit_host'] = nil
default['monit']['config']['poll_freq'] = 90
default['monit']['config']['start_delay'] = 10
default['monit']['config']['log_file'] = '/var/log/monit.log'
default['monit']['config']['id_file'] = '/var/lib/monit.id'
default['monit']['config']['state_file'] = '/var/run/monit.state'
default['monit']['config']['mailservers'] = [
  {
   :hostname => 'localhost',
   :port => 25,
   :username => nil,
   :password => nil,
   :security => nil,
   :timeout => "30 seconds",
  }
]
default['monit']['config']['subscribers'] = ["root@localhost"]
default['monit']['config']['eventqueue_dir'] = "/var/tmp"
default['monit']['config']['eventqueue_slots'] = 100
default['monit']['config']['listen_port'] = 2812
default['monit']['config']['listen_addr'] = "127.0.0.1"
default['monit']['config']['listen_allow'] = ["localhost"]
default['monit']['config']['mail_from'] = "monit@#{node['fqdn']}"
default['monit']['config']['mail_subject'] = "$SERVICE $EVENT at $DATE"
default['monit']['config']['mail_message'] = <<-EOT
  Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
  Yours sincerely,
  monit
EOT
