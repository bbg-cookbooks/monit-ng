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
end
