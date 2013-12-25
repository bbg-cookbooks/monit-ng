actions :install, :remove
default_action :install

VALID_SERVICE_IDS =
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
attribute :service_type, :kind_of => String, :default => "process", \
  :equal_to => ["process",
                "file",
                "fifo",
                "filesystem",
                "directory",
                "host",
                "system",
                "program"]
attribute :service_id, :kind_of => String, :required => true, :default => nil
attribute :service_type_id, :kind_of => String, :default => VALID_SERVICE_IDS[:service_id]
attribute :start_as, :kind_of => String, :default => nil
attribute :start_command, :kind_of => String, :default => nil
attribute :stop_command, :kind_of => String, :default => nil
attribute :service_group, :kind_of => String, :default => "system"
attribute :service_tests, :kind_of => Array, :default => []
attribute :every, :kind_of => String, :default => nil
def initialize(*args)
  super
  @action = :install
  @supports = { :report => true, :exception => true }
end
