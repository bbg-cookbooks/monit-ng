#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'

  source['version'] = '5.12'

  source['checksum'] =
    '43075396203569f87b67f7bffd1de739aa2fba302956237a2b0dc7aaf62da343'

  source['prefix'] = '/usr/local'

  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
