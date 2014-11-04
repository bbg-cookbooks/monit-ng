#
# Cookbook Name: monit
# Provider:: check
#

require 'chef/provider/template'
require 'chef/resource/template'

class Chef
  class Provider
    class MonitCheck < Chef::Provider
      use_inline_resources if defined?(use_inline_resources)

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

      def edit_check(exec_action)
        t = Chef::Resource::Template.new(tpl_name, run_context)
        t.cookbook new_resource.cookbook
        t.path tpl_path
        t.source 'monit.check.erb'
        t.variables monit_check_config
        t.notifies :reload, 'service[monit]', :delayed
        t.run_action exec_action
        t.updated_by_last_action?
      end

      def tpl_name
        "monit_check_#{new_resource.name}"
      end

      def tpl_path
        ::File.join(node['monit']['conf_dir'], "#{new_resource.name}.conf")
      end

      def monit_check_config
        {
          :name => new_resource.name, :check_type => new_resource.check_type,
          :check_id => new_resource.check_id, :id_type => new_resource.id_type,
          :group => new_resource.group, :start_as => new_resource.start_as,
          :start => new_resource.start, :stop => new_resource.stop,
          :every => new_resource.every, :tests => new_resource.tests
        }
      end
    end
  end
end
