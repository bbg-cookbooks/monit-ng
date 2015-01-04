#
# Cookbook Name: monit-ng
# Attributes: source
#

include_attribute 'monit-ng::default'

default['monit']['source'].tap do |source|
  source['url'] = 'https://mmonit.com/monit/dist'

  source['version'] = '5.11'

  source['checksum'] =
    'd507957b1e18e6f45af5a4d3f94529ab22b26f522f5f62287919bc905c44283a'

  source['prefix'] = '/usr/local'

  source['build_deps'] = value_for_platform_family(
    'rhel'    => %w( pam-devel openssl-devel ),
    'debian'  => %w( libpam0g-dev libssl-dev ),
    'default' => [],
  )
end
