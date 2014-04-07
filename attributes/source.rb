#
# Cookbook Name: monit
# Attributes: source
#

include_attribute 'monit::default'

default['monit']['source']['url'] = 'https://mmonit.com/monit/dist'
default['monit']['source']['version'] = '5.8'
default['monit']['source']['prefix'] = '/usr/local'
default['monit']['source']['checksum'] =
  'b2eb92d3c76a3161ffdd3b3ec0e5960fd900fac2'
default['monit']['source']['build_deps'] =
  value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
