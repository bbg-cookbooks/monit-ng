#
# Cookbook Name:: monit
# Recipe:: source
#

source = node['monit']['source']

# Setup/install build dependencies
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

# Download source package
source_url = "#{source['url']}/monit-#{source['version']}.tar.gz"
download_path = "#{Chef::Config['file_cache_path'] || '/tmp'}"
source_file_path = "#{download_path}/monit-#{source['version']}.tar.gz"
build_root = "#{download_path}/monit-#{source['version']}"

remote_file "source_archive" do
  source source_url
  checksum source['checksum']
  path source_file_path
  backup false
end

# Build source package
bash "extract_source_archive" do
  cwd download_path
  code <<-EOC
    tar xzf #{::File.basename(source_file_path)} -C #{download_path}
  EOC
  not_if { ::File.directory?("#{build_root}") }
end

monit_bin = "#{source['prefix']}/bin/monit"

ver_reg = Regexp.new("#{source['version']}$")

opts = "--prefix=#{source['prefix']}"

# handles case for a now-fixed multi-arch bug in monit < 5.6
if platform_family?("debian") && source['version'].to_f < 5.6
  opts += " --with-ssl-lib-dir=/usr/lib/#{node['kernel']['machine']}-linux-gnu"
end

bash "compile_source" do
  cwd build_root
  code <<-EOC
    ./configure #{opts} && make && make install
  EOC
  not_if do
    ::File.executable?(monit_bin) &&
    Mixlib::ShellOut.new(monit_bin, "-V").run_command.stdout.match(ver_reg)
  end
end

# Configure service
template '/etc/init.d/monit' do
  source 'monit.init.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  variables({
    :platform_family => node['platform_family'],
    :binary => monit_bin,
    :conf_file => node['monit']['conf_file'],
  })
end
