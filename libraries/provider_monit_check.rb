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
        @tpl = Chef::Resource::Template.new(new_resource.name, run_context)
        @srv = service('monit')
      end

      def load_current_resource
        @current_resource || Chef::Resource::MonitCheck.new(new_resource.name)
        build_template
      end

      def action_create
        @tpl.run_action(:create)
        new_resource.notifies(:restart, @srv, :delayed)
        new_resource.updated_by_last_action(true) if tpl_updated
      end

      def action_remove
        @tpl.run_action(:delete)
        new_resource.notifies(:restart, @srv, :delayed)
        new_resource.updated_by_last_action(true) if tpl_updated
      end

      private

      def tpl_updated
        @tpl.updated_by_last_action?
      end

      def build_template
        @tpl.cookbook(new_resource.cookbook)
        @tpl.path(tpl_path)
        @tpl.source('monit.check.erb')
        @tpl.owner('root')
        @tpl.group('root')
        @tpl.mode('0600')
        @tpl.variables(monit_check_config)
        @tpl.notifies(:restart, 'service[monit]', :immediately)
        @tpl.action(:nothing)
      end

      def tpl_path
        ::File.join(node.monit.conf_dir, "#{new_resource.name}.conf")
      end

      def monit_check_config
        {
          :name => new_resource.name, :check_type => new_resource.check_type,
          :check_id => new_resource.check_id, :id_type => new_resource.id_type,
          :group => new_resource.group, :start_as => new_resource.start_as,
          :start => new_resource.start, :stop => new_resource.stop,
          :every => new_resource.every, :tests => new_resource.tests,
        }
      end
    end
  end
end
