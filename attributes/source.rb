#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'

  source['version'] = '5.24.0'

  source['checksum'] =
    '754d1f0e165e5a26d4639a6a83f44ccf839e381f2622e0946d5302fa1f2d2414'

  source['prefix'] = '/usr/local'

  source['build_deps'] = value_for_platform_family(
    %w[rhel amazon] => %w[pam-devel openssl-devel],
    'debian'  => %w[libpam0g-dev libssl-dev],
    'default' => []
  )
end
