#
# Cookbook Name:: monit
# Resource:: check
# Provider:: check
#

require 'chef/resource/lwrp_base'
require 'chef/provider/lwrp_base'
require 'chef/mixin/params_validate'

class Chef::Resource
  # rubocop: disable ClassLength
  class MonitCheck < Chef::Resource::LWRPBase
    include Chef::Mixin::ParamsValidate

    resource_name :monit_check
    provides :monit_check

    actions :create, :delete, :remove
    default_action :create

    attribute :cookbook, kind_of: String, default: 'monit-ng'
    attribute :start, kind_of: String, callbacks: {
      'does not exceed max arg length' => ->(spec) { spec.length < 127 }
    }
    attribute :stop, kind_of: String, callbacks: {
      'does not exceed max arg length' => ->(spec) { spec.length < 127 }
    }
    attribute :mode, kind_of: String
    attribute :start_as, kind_of: String
    attribute :start_timeout, kind_of: [String, Integer]
    attribute :stop_as, kind_of: String
    attribute :stop_timeout, kind_of: [String, Integer]
    attribute :group, kind_of: [Array, String], default: []
    attribute :depends, kind_of: String
    attribute :tests, kind_of: Array, default: []
    attribute :every, kind_of: String
    attribute :alert, kind_of: String

    def check_type(arg = nil)
      set_or_return(
        :check_type, arg,
        kind_of: String,
        default: 'process',
        equal_to: check_pairs.keys
      )
    end

    def check_id(arg = nil)
      set_or_return(
        :check_id, arg,
        kind_of: String,
        required: !(check_type == 'system')
      )
    end

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def id_type(arg = nil)
      set_or_return(
        :id_type, arg,
        kind_of: String,
        equal_to: check_pairs.values.flatten.uniq,
        default: check_pairs[check_type].first,
        callbacks: {
          'is a valid id_type for check_type' => lambda do |spec|
            check_pairs[check_type].include?(spec) || check_type == 'system'
          end
        }
      )
    end
    # rubocop: enable MethodLength
    # rubocop: enable AbcSize

    def start_as_group(arg = nil)
      set_or_return(
        :start_as_group, arg,
        kind_of: String,
        required: start_as
      )
    end

    def stop_as_group(arg = nil)
      set_or_return(
        :stop_as_group, arg,
        kind_of: String,
        required: stop_as
      )
    end

    def but_not_on(arg = nil)
      set_or_return(
        :but_not_on, arg,
        kind_of: [TrueClass, FalseClass],
        default: false,
        required: alert
      )
    end

    def alert_events(arg = nil)
      set_or_return(
        :alert_events, arg,
        kind_of: Array,
        default: [],
        required: alert
      )
    end

    # rubocop: disable AbcSize
    def to_hash
      {
        name: name, check_type: check_type, check_id: check_id,
        id_type: id_type, mode: mode, group: group, depends: depends,
        start: start, start_as: start_as, start_as_group: start_as_group,
        stop: stop, stop_as: stop_as, stop_as_group: stop_as_group,
        start_timeout: start_timeout, stop_timeout: stop_timeout,
        every: every, tests: tests, alert: alert, but_not_on: but_not_on,
        alert_events: alert_events
      }
    end
    # rubocop: enable AbcSize

    private

    def check_pairs
      {
        'process' => %w( pidfile matching ), 'procmatch' => %w( matching ),
        'file' => %w( path ), 'fifo' => %w( path ),
        'filesystem' => %w( path ), 'directory' => %w( path ),
        'host' => %w( address ), 'system' => %w(),
        'program' => %w( path ),
        'device' => %w( path )
      }
    end
  end
  # rubocop: enable ClassLength
end

class Chef::Provider
  class MonitCheck < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :monit_check

    %i( create delete remove ).each do |a|
      action a do
        r = new_resource

        t = template tpl_path(r) do
          cookbook r.cookbook
          source 'monit.check.erb'
          variables r.to_hash
          if Chef::VERSION.to_f >= 12
            verify do |path|
              "monit -tc #{path}"
            end
          end
          action a == :create ? :create : :delete
        end

        new_resource.updated_by_last_action(t.updated_by_last_action?)
      end
    end

    private

    def tpl_path(resource)
      ::File.join(node['monit']['conf_dir'], "#{resource.name}.conf")
    end
  end
end
