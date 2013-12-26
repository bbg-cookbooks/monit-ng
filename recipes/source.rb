#
# Cookbook Name:: monit
# Recipe:: source
#

node.default['monit']['conf_file'] = "/etc/monitrc"

monit_url = node['monit']['source']['url'] ||
  "https://mmonit.com/monit/dist/monit-#{node['monit']['source']['version']}.tar.gz"

src_filepath = "#{Chef::Config['file_cache_path'] || '/tmp'}/monit-#{node['monit']['source']['version']}.tar.gz"

include_recipe "apt" if platform_family?("debian")
include_recipe "build-essential"

build_deps = value_for_platform(
  ["centos","redhat","fedora","scientific"] => {'default' => ['pam-devel','openssl-devel']},
   "default" => ['libpam0g-dev','libssl-dev']
)

build_deps.each do |build_dep|
  package build_dep
end

directory node['monit']['conf_dir'] do
  owner "root"
  group "root"
  mode 0600
  action :create
  recursive true
end

remote_file monit_url do
  source monit_url
  checksum node['monit']['source']['checksum']
  path src_filepath
  backup false
end

opts = "--prefix=#{node['monit']['source']['prefix']}"

# handles case for a now-fixed multi-arch bug in monit < 5.6
if platform_family?("debian") && node['monit']['source']['version'].to_f < 5.6
  opts += " --with-ssl-lib-dir=/usr/lib/#{node['kernel']['machine']}-linux-gnu"
end

bash "compile_monit_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xzf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)} &&
    cd monit-#{node['monit']['source']['version']} &&
    ./configure #{opts} && make && make install
  EOH
  notifies :restart, "service[monit]"
end

template '/etc/init.d/monit' do
  source 'monit.init.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  variables({
    :prefix => node['monit']['source']['prefix'],
  })
end

include_recipe "monit::config"
