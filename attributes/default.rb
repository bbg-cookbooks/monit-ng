
default['monit']['install_method'] = "repo"

case node['platform_family']
when "debian"
  default['monit']['conf_file'] = "/etc/monit/monitrc"
  default['monit']['conf_dir'] = "/etc/monit/conf.d"
when "rhel"
  default['monit']['conf_file'] = "/etc/monit.conf"
  default['monit']['conf_dir'] = "/etc/monit.d"
else
  default['monit']['conf_file'] = "/etc/monitrc"
  default['monit']['conf_dir'] = "/etc/monit.d"
end
