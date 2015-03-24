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
          :default => 'monit-ng'
        )
      end

      def check_type(arg = nil)
        set_or_return(
          :check_type, arg,
          :kind_of => String,
          :equal_to => check_pairs.keys,
          :default => 'process'
        )
      end

      def check_id(arg = nil)
        set_or_return(
          :check_id, arg,
          :kind_of => String,
          :required => true
        )
      end

      # rubocop: disable MethodLength
      def id_type(arg = nil)
        set_or_return(
          :id_type, arg,
          :kind_of => String,
          :equal_to => check_pairs.values.flatten.uniq,
          :default => check_pairs[check_type].first,
          :callbacks => {
            'is a valid id_type for check_type' => lambda do |spec|
              check_pairs[check_type].include?(spec)
            end,
          }
        )
      end
      # rubocop: enable MethodLength

      def start_as(arg = nil)
        set_or_return(
          :start_as, arg,
          :kind_of => String
        )
      end

      def start_as_group(arg = nil)
        set_or_return(
          :start_as_group, arg,
          :kind_of => String,
          :required => start_as
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
          }
        )
      end

      def stop_as(arg = nil)
        set_or_return(
          :stop_as, arg,
          :kind_of => String
        )
      end

      def stop_as_group(arg = nil)
        set_or_return(
          :stop_as_group, arg,
          :kind_of => String,
          :required => stop_as
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
          }
        )
      end

      def group(arg = nil)
        set_or_return(
          :group, arg,
          :kind_of => String
        )
      end

      def tests(arg = nil)
        set_or_return(
          :tests, arg,
          :kind_of => Array,
          :default => []
        )
      end

      def every(arg = nil)
        set_or_return(
          :every, arg,
          :kind_of => String
        )
      end

      private

      def check_pairs
        {
          'process' => %w( pidfile matching ), 'procmatch' => %w( matching ),
          'file' => %w( path ), 'fifo' => %w( path ),
          'filesystem' => %w( path ), 'directory' => %w( path ),
          'host' => %w( address ), 'system' => %w(),
          'program' => %w( path )
        }
      end
    end
    # rubocop: enable ClassLength
  end
end
