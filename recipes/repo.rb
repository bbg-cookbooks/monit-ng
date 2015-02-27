#
# Cookbook Name:: monit-ng
# Recipe:: repo
#

# Monit is not in the default repositories
include_recipe 'yum-epel' if platform_family?('rhel') && !platform?('amazon')
include_recipe 'apt' if platform_family?('debian')
include_recipe 'ubuntu' if platform?('ubuntu')

package 'monit'
