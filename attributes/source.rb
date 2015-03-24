#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'

  source['version'] = '5.12.2'

  source['checksum'] =
    '8ab0296d1aa2351b1573481592d7b5e06de1edd49dff1b5552839605a450914c'

  source['prefix'] = '/usr/local'

  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
