#
# Cookbook Name: monit
# Provider:: disk
#

require 'chef/provider/template'
require 'chef/resource/template'

class Chef
  class Provider
    class MonitDisk < Chef::Provider
      def initialize(*args)
        super
      end

      def load_current_resource
        @current_resource ||= Chef::Resource::MonitDisk.new(new_resource.name)
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
        t.source 'monit.disk.erb'
        t.variables monit_disk_config
        if Chef::VERSION.to_f >= 12
          t.verify do |path|
            "monit -tc #{path}"
          end
        end
        t.run_action exec_action
        t.updated_by_last_action?
      end

      def tpl_name
        "monit_disk_#{new_resource.name}"
      end

      def tpl_path
        ::File.join(node['monit']['conf_dir'], "disk_#{new_resource.name}.monit.conf")
      end

      def monit_disk_config
        {
          :device => new_resource.device,
          :path => new_resource.path,
          :checks => new_resource.checks,
        }
      end
    end
  end
end
