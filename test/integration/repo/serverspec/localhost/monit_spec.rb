require 'spec_helper'

describe 'Monit Daemon' do
  describe 'is installed' do
    describe package('monit') do
      it { should be_installed }
    end
  end

  describe 'is enabled, running' do
    describe service('monit') do
      it { should be_enabled }
    end
  end

  describe 'is running' do
    describe process('monit') do
      it { should be_running }
    end
  end

  describe 'is listening on port 2812' do
    describe port(2812) do
      it { should be_listening }
    end
  end

  
  conf_dir, conf_file = case os[:family]
                        when 'redhat'
                          ['/etc/monit.d', '/etc/monit.conf']
                        when 'debian', 'ubuntu'
                          ['/etc/monit/conf.d', '/etc/monit/monitrc']
                        else
                          ['/etc/monit.d', '/etc/monitrc']
                        end

  describe file(conf_dir) do
    it { should be_directory }
  end

  describe file(conf_file) do
    [
      'set daemon 60',
      'with start delay 5',
      'set logfile /var/log/monit.log',
      'set idfile /var/lib/monit.id',
      'set statefile /var/run/monit.state',
      'set mail-format {',
      'from: monit',
      'subject: \$SERVICE \$EVENT at \$DATE',
      'message:     Monit',
      'set alert this@localhost',
      'only on { connection, content, data }',
      'set alert that@localhost',
      'but not on { nonexist }',
      'set alert theother@localhost',
      'only on { size, timeout, timestamp, uid }',
      'set eventqueue',
      'basedir /var/tmp',
      'slots 100',
      'set httpd port 2812 and',
      'use address 127.0.0.1',
      'allow localhost',
      "include #{conf_dir}/\\*\.conf",
    ].each do |directive|
      its(:content) { should match Regexp.new(directive) }
    end
  end
end
