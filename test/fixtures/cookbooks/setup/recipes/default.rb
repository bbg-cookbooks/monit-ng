
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
  'ntpd' => 'OPTIONS="-g -p /var/run/ntpd.pid"',
  'rsyslog' => 'SYSLOGD_OPTIONS="-i /var/run/syslogd.pid"',
}.each_pair do |svc, cfg|
  file "/etc/sysconfig/#{svc}" do
    content cfg
    only_if { platform_family?('rhel') && node['platform_version'].to_f >= 7.0 }
    notifies :restart, "service[#{svc}]", :delayed
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
