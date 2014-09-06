#
# Cookbook Name: monit
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'
  source['version'] = '5.8.1'
  source['prefix'] = '/usr/local'
  source['checksum'] = 'a25e4b79257ac29ebaf46605dccb7ed693c8e001669c0ccc8feb22e7d4c870e5'
  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
