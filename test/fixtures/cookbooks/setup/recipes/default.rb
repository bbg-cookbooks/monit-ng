
value_for_platform_family(
  'rhel'   => %w( cronie openssh-server ),
  'debian' => %w( cron ssh ),
).each do |pkg|
  package pkg
end

%w( ntp postfix rsyslog ).each do |pkg|
  package pkg
end

{
  '/etc/sysconfig/ntpd' => 'OPTIONS="-g -p /var/run/ntpd.pid"',
  '/etc/sysconfig/rsyslog' => 'SYSLOGD_OPTIONS="-i /var/run/rsyslog.pid"',
}.each_pair do |cnf, val|
  file cnf do
    content val
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 7.0 }
  end
end

%w( crond sshd ntpd postfix rsyslog ).each do |svc|
  service svc do
    action [:enable, :start]
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 7.0 }
  end
end

%w( crond ntpd postfix rootfs rsyslog sshd ).each do |chk|
  include_recipe "monit-ng::#{chk}"
end
