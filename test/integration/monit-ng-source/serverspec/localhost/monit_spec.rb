require 'spec_helper'

describe 'Monit Daemon' do
  describe 'is enabled' do
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

  describe 'is monitoring the root filesystem' do
    describe command('monit summary') do
      its(:stdout) { should match /rootfs/ }
    end
  end

  %w( crond ntpd postfix rsyslog sshd ).each do |svc|
    describe "is monitoring #{svc}" do
      describe service(svc) do
        it { should be_monitored_by 'monit' }
      end
    end
  end
end
