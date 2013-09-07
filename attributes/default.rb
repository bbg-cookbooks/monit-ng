case node['platform_family']
when "rhel"
  default['monit']['conf_file'] = "/etc/monit.conf"
  default['monit']['conf_dir'] = "/etc/monit.d"
when "debian"
  default['monit']['conf_file'] = "/etc/monit/monitrc"
  default['monit']['conf_dir'] = "/etc/monit/conf.d"
end

default['monit']['config']['poll_freq'] = 90
default['monit']['config']['start_delay'] = 60
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
default['monit']['config']['mail_message'] = <<EOT 
  Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
  Yours sincerely,
  monit
EOT
default['monit']['config']['mmonit_host'] = nil
default['monit']['install_method'] = "repo"
default['monit']['source']['url'] = nil
default['monit']['source']['version'] = "5.6"
default['monit']['source']['checksum'] = "38e09bd8b39abc59e6b9a9bb7a78f7eac2b02a92f4de1f3a6dc24e84dfedae0d"
default['monit']['source']['prefix'] = "/usr/local"
