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

  describe 'is monitoring sshd' do
    describe service('sshd') do
      it { should be_monitored_by('monit') }
    end
  end

  describe 'is monitoring crond' do
    describe service('crond') do
      it { should be_monitored_by('monit') }
    end
  end
end
