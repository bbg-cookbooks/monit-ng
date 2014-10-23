#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'
  source['version'] = '5.9'
  source['prefix'] = '/usr/local'
  source['checksum'] = 'f5fd22e865670ee4e538b2cc040ced880ba52a4f'
  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
