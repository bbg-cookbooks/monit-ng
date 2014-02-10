
case node['platform_family']
when 'rhel'
  package 'cronie'
when 'debian'
  package 'cron'
end
