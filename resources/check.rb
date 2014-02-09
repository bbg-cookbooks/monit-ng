#
# Cookbook Name:: monit
# Resource:: check
#

actions :install, :uninstall
default_action :install

# Reference for validation
VALID_CHECK_PAIRS =
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

attribute :name,       :kind_of => String, :name_attribute => true
attribute :cookbook,   :kind_of => String, :default => 'monit'
attribute :check_id,   :kind_of => String, :required => true, :default => nil
attribute :id_type,    :kind_of => String, :default => 'pidfile',
                       :equal_to => VALID_CHECK_PAIRS.values
attribute :start_as,   :kind_of => String, :default => nil
attribute :start,      :kind_of => String, :default => nil
attribute :stop,       :kind_of => String, :default => nil
attribute :group,      :kind_of => String, :default => 'system'
attribute :tests,      :kind_of => Array,  :default => []
attribute :every,      :kind_of => String, :default => nil
attribute :check_type, :kind_of => String, :default => 'process',
                       :equal_to => VALID_CHECK_PAIRS.keys

def initialize(*args)
  super
  @action = :install
  @supports = { :report => true, :exception => true }
end
