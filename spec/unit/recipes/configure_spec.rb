require 'spec_helper'

describe 'monit-ng::configure' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
      .converge(described_recipe)
    end

    it 'creates the global config' do
      expect(chef_run).to create_template('/etc/monit.conf')
    end

    it 'creates the includes path' do
      expect(chef_run).to create_directory('/etc/monit.d')
    end
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
      .converge(described_recipe)
    end

    it 'creates the global config' do
      expect(chef_run).to create_template('/etc/monit/monitrc')
    end

    it 'creates the includes path' do
      expect(chef_run).to create_directory('/etc/monit/conf.d')
    end
  end

  it 'creates the global config' do
    expect(chef_run).to create_template('/etc/monitrc')
  end

  it 'creates the includes path' do
    expect(chef_run).to create_directory('/etc/monit.d')
  end
end
