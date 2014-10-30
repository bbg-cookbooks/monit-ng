#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'
  source['version'] = '5.10'
  source['prefix'] = '/usr/local'
  source['checksum'] =
    '3791155a1b1b6b51a4a104dfe6f17b37d7c346081889f1bec9339565348d9453'
  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
