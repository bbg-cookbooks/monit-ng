#
# Cookbook Name:: monit
# Recipe:: source
#

source = node['monit']['source']

include_recipe 'apt' if platform_family?('debian')
include_recipe 'build-essential'

build_deps = value_for_platform(
  %w{centos redhat fedora scientific} => {
    'default' => %w{pam-devel openssl-devel}
  },
  'default' => %w{libpam0g-dev libssl-dev}
)

build_deps.each do |build_dep|
  package build_dep
end

monit_bin = "#{source['prefix']}/bin/monit"

source_url = "#{source['url']}/monit-#{source['version']}.tar.gz"

download_path = Chef::Config['file_cache_path'] || '/tmp'

source_file_path = "#{download_path}/monit-#{source['version']}.tar.gz"

build_root = "#{download_path}/monit-#{source['version']}"

opts = "--prefix=#{source['prefix']}"

if platform_family?('debian') && source['version'].to_f < 5.6
  opts += " --with-ssl-lib-dir=/usr/lib/#{node['kernel']['machine']}-linux-gnu"
end

remote_file source_file_path do
  source source_url
  checksum source['checksum']
  path source_file_path
  backup false
  notifies :run, 'execute[extract-source-archive]', :immediately
end

execute 'extract-source-archive' do
  cwd download_path
  command <<-EOC
    tar xzf #{::File.basename(source_file_path)} -C #{download_path}
  EOC
  action :nothing
  notifies :run, 'execute[compile-source]', :immediately
end

execute 'compile-source' do
  cwd build_root
  command <<-EOC
    ./configure #{opts} && make && make install
  EOC
  action :nothing
end

template '/etc/init.d/monit' do
  source 'monit.init.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  variables(
    :platform_family => node['platform_family'],
    :binary          => monit_bin,
    :conf_file       => node['monit']['conf_file'],
  )
end
