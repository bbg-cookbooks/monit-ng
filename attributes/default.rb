#
# Cookbook Name: monit
# Attributes: default
#

default['monit']['install_method'] = 'repo'
default['monit']['configure'] = true

case node['platform_family']
when 'debian'
  default['monit']['conf_file'] = '/etc/monit/monitrc'
  default['monit']['conf_dir'] = '/etc/monit/conf.d'
when 'rhel'
  default['monit']['conf_file'] = '/etc/monit.conf'
  default['monit']['conf_dir'] = '/etc/monit.d'
else
  default['monit']['conf_file'] = '/etc/monitrc'
  default['monit']['conf_dir'] = '/etc/monit.d'
end
