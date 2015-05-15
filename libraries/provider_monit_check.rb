#
# Cookbook Name: monit
# Provider:: check
#

require 'chef/provider/template'
require 'chef/resource/template'

class Chef
  class Provider
    class MonitCheck < Chef::Provider
      def initialize(*args)
        super
      end

      def load_current_resource
        @current_resource ||= Chef::Resource::MonitCheck.new(new_resource.name)
      end

      def action_create
        new_resource.updated_by_last_action(edit_check(:create))
      end

      def action_remove
        new_resource.updated_by_last_action(edit_check(:delete))
      end

      private

      # rubocop: disable MethodLength
      # rubocop: disable AbcSize
      def edit_check(exec_action)
        t = Chef::Resource::Template.new(tpl_name, run_context)
        t.cookbook new_resource.cookbook
        t.path tpl_path
        t.source 'monit.check.erb'
        t.variables monit_check_config
        t.notifies :reload, 'service[monit]', :delayed
        if Chef::VERSION.to_f >= 12
          t.verify do |path|
            "monit -tc #{path}"
          end
        end
        t.run_action exec_action
        t.updated_by_last_action?
      end
      # rubocop: enable MethodLength
      # rubocop: enable AbcSize

      def tpl_name
        "monit_check_#{new_resource.name}"
      end

      def tpl_path
        ::File.join(node['monit']['conf_dir'], "#{new_resource.name}.conf")
      end

      # rubocop: disable AbcSize
      def monit_check_config
        {
          :name => new_resource.name, :check_type => new_resource.check_type,
          :check_id => new_resource.check_id, :id_type => new_resource.id_type,
          :group => new_resource.group, :start_as => new_resource.start_as,
          :start_as_group => new_resource.start_as_group,
          :start => new_resource.start, :stop => new_resource.stop,
          :stop_as => new_resource.stop_as,
          :stop_as_group => new_resource.stop_as_group,
          :every => new_resource.every, :tests => new_resource.tests
        }
      end
      # rubocop: enable AbcSize
    end
  end
end
