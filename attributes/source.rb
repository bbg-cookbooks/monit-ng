#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'

  source['version'] = '5.12.1'

  source['checksum'] =
    '0ed2489d31313fb9f7b6867352609c8aa416c3c19be3761142356d0a9cfa41c9'

  source['prefix'] = '/usr/local'

  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
