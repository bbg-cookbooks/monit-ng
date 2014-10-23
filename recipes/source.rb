#
# Cookbook Name:: monit-ng
# Recipe:: source
#

source = node['monit']['source']

include_recipe 'apt' if platform_family?('debian')
include_recipe 'build-essential'

source['build_deps'].each do |build_dep|
  package build_dep
end

source_url = "#{source['url']}/monit-#{source['version']}.tar.gz"
download_path = Chef::Config['file_cache_path'] || '/tmp'
source_file_path = "#{download_path}/monit-#{source['version']}.tar.gz"
build_root = "#{download_path}/monit-#{source['version']}"

monit_bin = "#{source['prefix']}/bin/monit"
opts = "--prefix=#{source['prefix']}"
if platform_family?('debian') && source['version'].to_f < 5.6
  opts += " --with-ssl-lib-dir=/usr/lib/#{node['kernel']['machine']}-linux-gnu"
end

execute 'compile-source' do
  cwd build_root
  command <<-EOC
    ./configure #{opts} && make && make install
  EOC
  action :nothing
end

execute 'extract-source-archive' do
  cwd download_path
  command <<-EOC
    tar xzf #{::File.basename(source_file_path)} -C #{download_path}
  EOC
  action :nothing
  notifies :run, 'execute[compile-source]', :immediately
end

remote_file 'source-archive' do
  source source_url
  path source_file_path
  checksum source['checksum']
  path source_file_path
  backup false
  notifies :run, 'execute[extract-source-archive]', :immediately
end

# this is the upstream default config
# path. we link it to the platform
# default rather than patching the source,
# which would require carrying multiple
# patches for different versions; this
# also allows calling monit without passing
# the path to the global config file as an argument
link '/etc/monitrc' do
  to node['monit']['conf_file']
  not_if { node['monit']['conf_file'] == '/etc/monitrc' }
end

# OK then, hang onto your butts
init_config = {
  :platform_family => node['platform_family'],
  :binary          => monit_bin,
  :conf_file       => node['monit']['conf_file'],
}

# Upstart Config
execute 'reload-upstart-configuration' do
  command 'initctl reload-configuration'
  action :nothing
end

template 'monit-upstart-init' do
  path '/etc/init/monit.conf'
  source 'monit.upstart.erb'
  mode '0644'
  variables init_config
  notifies :run, 'execute[reload-upstart-configuration]', :immediately
  action :nothing
end

# SystemD Config
execute 'reload-systemd-configuration' do
  command 'systemctl daemon-reload'
  action :nothing
end

template 'monit-systemd-init' do
  path '/lib/systemd/system/monit.service'
  source 'monit.service.erb'
  mode '0644'
  variables init_config
  notifies :run, 'execute[reload-systemd-configuration]', :immediately
  action :nothing
end

# SysV Config
template 'monit-sysv-init' do
  path '/etc/init.d/monit'
  source 'monit.init.erb'
  mode '0755'
  variables init_config
  action :nothing
end

# Doctor? Where am I?
ruby_block 'configure-system-init' do
  block do
    case node.platform_family?
    when 'debian'
      if node.platform?('ubuntu') && node.platform_version.to_f >= 12.04
        resources(:template => 'monit-upstart-init').run_action(:create)
      else
        resources(:template => 'monit-sysv-init').run_action(:create)
      end
    when 'rhel'
      if node.platform_version.to_f >= 7.0
        resources(:template => 'monit-systemd-init').run_action(:create)
      else
        resources(:template => 'monit-sysv-init').run_action(:create)
      end
    else
      resources(:template => 'monit-sysv-init').run_action(:create)
    end
  end
end
