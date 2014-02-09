#
# Cookbook Name: monit
# Attributes: source
#

include_attribute 'monit::default'

default['monit']['source']['url'] = 'https://mmonit.com/monit/dist'
default['monit']['source']['version'] = '5.6'
default['monit']['source']['prefix'] = '/usr/local'
default['monit']['source']['checksum'] =
  '38e09bd8b39abc59e6b9a9bb7a78f7eac2b02a92f4de1f3a6dc24e84dfedae0d'
default['monit']['source']['build_deps'] =
  value_for_platform_family(
    'rhel'    => %w{pam-devel openssl-devel},
    'debian'  => %w{libpam0g-dev libssl-dev},
    'default' => %w{},
  )
