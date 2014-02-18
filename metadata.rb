name             'monit'
maintainer       'Nathan Williams'
maintainer_email 'nwilliams@bluebox.net'
license          'Apache 2.0'
description      'Installs and configures monit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.0'

depends 'yum-epel'
depends 'ubuntu'
depends 'apt'
depends 'build-essential'

%w{redhat scientific centos fedora debian ubuntu}.each do |platform|
  supports platform
end
