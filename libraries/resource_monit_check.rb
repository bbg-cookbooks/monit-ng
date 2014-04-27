#
# Cookbook Name:: monit
# Resource:: check
#

require 'chef/resource'

class Chef
  class Resource
    # rubocop: disable ClassLength
    class MonitCheck < Chef::Resource
      identity_attr :name

      def initialize(name, run_context = nil)
        super
        @resource_name = :monit_check
        @provider = Chef::Provider::MonitCheck
        @action = :create
        @allowed_actions = [:create, :remove]
        @name = name
      end

      def cookbook(arg = nil)
        set_or_return(
          :cookbook, arg,
          :kind_of => String,
          :default => 'monit',
        )
      end

      def check_type(arg = nil)
        set_or_return(
          :check_type, arg,
          :kind_of => String,
          :equal_to => check_pairs.keys,
          :default => 'process',
        )
      end

      def check_id(arg = nil)
        set_or_return(
          :check_id, arg,
          :kind_of => String,
          :required => true,
        )
      end

      # rubocop: disable MethodLength
      def id_type(arg = nil)
        set_or_return(
          :id_type, arg,
          :kind_of => String,
          :equal_to => check_pairs.values,
          :default => check_pairs[check_type],
          :callbacks => {
            'is a valid id_type for check_type' => lambda do |spec|
              spec == check_pairs[check_type]
            end,
          },
        )
      end
      # rubocop: enable MethodLength

      def start_as(arg = nil)
        set_or_return(
          :start_as, arg,
          :kind_of => String,
        )
      end

      def start(arg = nil)
        set_or_return(
          :start, arg,
          :kind_of => String,
          :callbacks => {
            'does not exceed max arg length' => lambda do |spec|
              spec.length < 127
            end,
          },
        )
      end

      def stop(arg = nil)
        set_or_return(
          :stop, arg,
          :kind_of => String,
          :callbacks => {
            'does not exceed max arg length' => lambda do |spec|
              spec.length < 127
            end,
          },
        )
      end

      def group(arg = nil)
        set_or_return(
          :group, arg,
          :kind_of => String,
        )
      end

      def tests(arg = nil)
        set_or_return(
          :tests, arg,
          :kind_of => Array,
          :default => [],
        )
      end

      def every(arg = nil)
        set_or_return(
          :every, arg,
          :kind_of => String,
        )
      end

      private

      def check_pairs
        {
          'process' => 'pidfile', 'procmatch' => 'matching',
          'file' => 'path', 'fifo' => 'path',
          'filesystem' => 'path', 'directory' => 'path',
          'host' => 'address', 'system' => nil,
          'program' => 'path',
        }
      end
    end
    # rubocop: enable ClassLength
  end
end
