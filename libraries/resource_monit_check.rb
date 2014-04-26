#
# Cookbook Name:: monit
# Resource:: check
#

require 'chef/resource'

class Chef
  class Resource
    class MonitCheck < Chef::Resource

    CHECK_PAIRS =
      {
        'process'    => 'pidfile',
        'procmatch'  => 'matching',
        'file'       => 'path',
        'fifo'       => 'path',
        'filesystem' => 'path',
        'directory'  => 'path',
        'host'       => 'address',
        'system'     => nil,
        'program'    => 'path',
      }

    def initialize(name, run_context=nil)
      super
      @resource_name = :monit_check
      @provider = Chef::Provider::MonitCheck
      @action = :create
      @allowed_actions = [:create, :remove]
      @name = name
    end

    def cookbook(arg = 'monit')
      set_or_return(
        :cookbook, arg,
        :kind_of => String
      )
    end

    def check_type(arg = 'process')
      set_or_return(
        :check_type, arg,
        :kind_of => String,
        :equal_to => CHECK_PAIRS.keys,
        :required => true,
      )
    end

    def check_id(arg = nil)
      set_or_return(
        :check_id, arg,
        :kind_of => String,
      )
    end

    def id_type(arg = check_id_type)
      set_or_return(
        :id_type, arg,
        :kind_of => String,
        :equal_to => CHECK_PAIRS.values,
      )
    end

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
#        :callback => lamda { |spec| spec.length < 127 }
      )
    end

    def stop(arg = nil)
      set_or_return(
        :stop, arg,
        :kind_of => String,
#        :callback => lamda { |spec| spec.length < 127 }
      )
    end

    def group(arg = 'system')
      set_or_return(
        :group, arg,
        :kind_of => String,
      )
    end

    def tests(arg = [])
      set_or_return(
        :tests, arg,
        :kind_of => Array,
      )
    end

    def every(arg = nil)
      set_or_return(
        :every, arg,
        :kind_of => String,
      )
    end

    def check_id_type
      CHECK_PAIRS[@check_type]
    end

    end
  end
end
