#
# Cookbook Name:: monit
# Recipe:: source
#

config = node['monit']['source']
monit_bin = "#{config['prefix']}/bin/monit"

monit_url = config['url'] ||
  "https://mmonit.com/monit/dist/monit-#{config['version']}.tar.gz"

src_filepath = "#{Chef::Config['file_cache_path'] || '/tmp'}/monit-#{config['version']}.tar.gz"

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
  checksum config['checksum']
  path src_filepath
  backup false
end

opts = "--prefix=#{config['prefix']}"

# handles case for a now-fixed multi-arch bug in monit < 5.6
if platform_family?("debian") && config['version'].to_f < 5.6
  opts += " --with-ssl-lib-dir=/usr/lib/#{node['kernel']['machine']}-linux-gnu"
end

bash "extract_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xzf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
  EOH
  not_if { ::File.directory?("#{File.dirname(src_filepath)}/monit-#{config['version']}") }
end

bash "compile_monit_source" do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    cd monit-#{config['version']} &&
    ./configure #{opts} && make && make install
  EOH

  not_if do
    ::File.executable?(monit_bin) &&
    Mixlib::ShellOut.new(monit_bin, "-V").run_command.stdout.match(Regexp.new("#{config['version']}$"))
  end
  notifies :restart, "service[monit]"
end

template '/etc/init.d/monit' do
  source 'monit.init.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  variables({
    :platform_family => node['platform_family'],
    :prefix => node['monit']['source']['prefix'],
    :config => node['monit']['conf_file']
  })
end

include_recipe "monit::config"
