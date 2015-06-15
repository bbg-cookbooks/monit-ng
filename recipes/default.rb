#
# Cookbook Name:: monit-ng
# Recipe:: default
#

%w( install configure service reload ).each do |r|
  include_recipe "#{cookbook_name}::#{r}"
end
