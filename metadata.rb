name             'monit-ng'
maintainer       'Nathan Williams'
maintainer_email 'nath.e.will@gmail.com'
license          'Apache 2.0'
description      'Installs and configures monit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.3.0'

%w( yum-epel ubuntu apt build-essential dpkg_autostart ).each do |dep|
  depends dep
end

%w( amazon redhat scientific centos debian ubuntu ).each do |platform|
  supports platform
end


unless defined?(Ridley::Chef::Cookbook::Metadata)
  source_url       'https://github.com/bbg-cookbooks/monit-ng'
  issues_url       'https://github.com/bbg-cookbooks/monit-ng/issues'
end
