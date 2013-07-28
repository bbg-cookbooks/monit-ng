#
# Author:: Nathan Williams <nath.e.will@gmail.com>
#
# Cookbook Name:: monit
# Attribute File:: default
#
# Copyright 2013, Nathan Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case node['platform_family']
  when "rhel"
    default['monit']['conf_file'] = "/etc/monit.conf"
    default['monit']['conf_dir'] = "/etc/monit.d"
  when "debian"
    default['monit']['conf_file'] = "/etc/monit/monitrc"
    default['monit']['conf_dir'] = "/etc/monit/conf.d"
end

default['monit']['config']['poll_freq'] = 90
default['monit']['config']['start_delay'] = 60
default['monit']['config']['log_file'] = '/var/log/monit.log'
default['monit']['config']['id_file'] = '/var/.monit.id'
default['monit']['config']['state_file'] = '/var/.monit.state'
default['monit']['config']['mailservers'] = [
  {
   :hostname => 'localhost',
   :port => 25,
   :username => nil,
   :password => nil,
   :security => nil,
   :timeout => "30 seconds",
  }
]
default['monit']['config']['subscribers'] = ['root@localhost']
default['monit']['config']['eventqueue_dir'] = "/var/tmp"
default['monit']['config']['eventqueue_slots'] = 100
default['monit']['config']['listen_port'] = 2812
default['monit']['config']['listen_addr'] = "127.0.0.1"
default['monit']['config']['listen_allow'] = ["localhost"]
default['monit']['config']['mail_from'] = "monit@#{node['fqdn']}"
default['monit']['config']['mail_subject'] = "$SERVICE $EVENT at $DATE"
default['monit']['config']['mail_message'] = <<EOT 
  Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
  Yours sincerely,
  monit
EOT
default['monit']['config']['mmonit_host'] = nil
default['monit']['install_method'] = "repo"
default['monit']['source']['url'] = nil
default['monit']['source']['version'] = "5.5.1"
default['monit']['source']['checksum'] = "dbe4b4744a7100e2d5f4eac353dfb2df0549848e2c7661d9c19acc31cdef2c78"
default['monit']['source']['prefix'] = "/usr/local"
