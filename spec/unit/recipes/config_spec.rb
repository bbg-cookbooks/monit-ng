require 'spec_helper'

describe 'monit-ng::config' do
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

  it 'enables the service' do
    expect(chef_run).to enable_service('monit')
  end

  it 'starts the service' do
    expect(chef_run).to start_service('monit')
  end

  # TODO: sort out stubbing the file existence to test that
  # monit::config creates /etc/default/monit when it should
  it 'does not un-disable the service by default' do
    expect(chef_run).to_not create_template('/etc/default/monit')
  end

  it 'creates the includes path' do
    expect(chef_run).to create_directory('/etc/monit.d')
  end

  it 'does not reload by default' do
    expect(chef_run).to_not run_ruby_block('reload-monit')
  end

  it 'runs delayed notification of ruby_block[reload-monit]' do
    expect(chef_run).to run_ruby_block('notify-reload-monit')
  end
end
