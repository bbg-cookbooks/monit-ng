#
# Author:: Nathan Williams <nath.e.will@gmail.com>
# Cookbook Name:: monit
# Recipe:: default
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

# epel repository is needed for the monit package on rhel
if platform_family?("rhel")
  include_recipe "yum::epel"
end

package 'monit' do
  action :install
end

service "monit" do
  service_name "monit"
  supports :status => true, :restart => true, :reload => true, :stop => true
  action [ :enable, :start ]
end

template node.monit.conf_file do
  source 'monit.conf.erb'
  owner 'root'
  mode '0600'
  variables({
    :daemon => node.monit.config.daemon,
    :start_delay => node.monit.config.start_delay,
    :log_file => node.monit.config.log_file,
    :id_file => node.monit.config.id_file,
    :state_file => node.monit.config.state_file,
    :mailservers => node.monit.config.mailservers,
    :subscribers => node.monit.config.subscribers,
    :eventqueue_dir => node.monit.config.eventqueue_dir,
    :eventqueue_slots => node.monit.config.eventqueue_slots,
    :address => node.monit.config.listen_addr,
    :port => node.monit.config.listen_port,
    :allow => node.monit.config.listen_allow,
    :mail_from => node.monit.config.mail_from,
    :mail_subject => node.monit.config.mail_subject,
    :mail_msg => node.monit.config.mail_message,
    :mmonit => node.monit.config.mmonit_host,
    :conf_dir => node.monit.conf_dir,
  })
  notifies :reload, "service[monit]", :immediately
end
