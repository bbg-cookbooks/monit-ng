actions :install, :remove
default_action :install

# Reference for validation
VALID_CHECK_IDS =
  {
    'process' => "pidfile",
    'procmatch' => "matching",
    'file' => "path",
    'fifo' => "path",
    'filesystem' => "path",
    'directory' => "path",
    'host' => "address",
    'system' => nil,
    'program' => "path",
  }

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => "monit"
attribute :check_type, :kind_of => String, :default => "process",
  :equal_to => %w{ process file fifo filesystem directory host system program }
attribute :check_id, :kind_of => String, :required => true, :default => nil
attribute :id_type, :kind_of => String, :default => 'pidfile'
attribute :start_as, :kind_of => String, :default => nil
attribute :start, :kind_of => String, :default => nil
attribute :stop, :kind_of => String, :default => nil
attribute :group, :kind_of => String, :default => "system"
attribute :tests, :kind_of => Array, :default => []
attribute :every, :kind_of => String, :default => nil

def initialize(*args)
  super
  @action = :install
  @supports = { :report => true, :exception => true }
end
