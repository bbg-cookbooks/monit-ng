#
# Cookbook Name:: monit
# Resource:: disk
#

require 'chef/resource'

class Chef
  class Resource
    class MonitDisk < Chef::Resource
      identity_attr :device

      def initialize(device, run_context = nil)
        super
        @resource_name = :monit_disk
        @provider = Chef::Provider::MonitDisk
        @action = :create
        @allowed_actions = [:create, :remove]
        device device
      end

      def cookbook(arg = nil)
        set_or_return(
          :cookbook, arg,
          :kind_of => String,
          :default => 'monit-ng'
        )
      end

      def device(arg = nil)
        set_or_return(
          :device, arg,
          :kind_of => String,
          :required => true
        )
      end

      def path(arg = nil)
        set_or_return(
          :path, arg,
          :kind_of => String,
          :required => true
        )
      end

      def checks(arg = nil)
        set_or_return(
          :checks, arg,
          :kind_of => Array,
          :default => []
        )
      end
    end
  end
end
