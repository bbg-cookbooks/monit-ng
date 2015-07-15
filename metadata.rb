name             'monit-ng'
maintainer       'Nathan Williams'
maintainer_email 'nath.e.will@gmail.com'
license          'Apache 2.0'
description      'Installs and configures monit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.2'

%w( yum-epel ubuntu apt build-essential ).each do |dep|
  depends dep
end

%w( amazon redhat scientific centos debian ubuntu ).each do |platform|
  supports platform
end
