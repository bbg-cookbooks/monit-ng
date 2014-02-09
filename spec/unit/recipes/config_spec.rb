require 'spec_helper'

describe 'monit::config' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:global_conf) { chef_run.template('/etc/monitrc') }

  context 'rhel' do
    let(:chef_run) do
      ChefSpec::Runner.new(:platform => 'centos', :version => '6.4')
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
      ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04')
      .converge(described_recipe)
    end

    it 'creates the global config' do
      expect(chef_run).to create_template('/etc/monit/monitrc')
    end

    it 'creates the includes path' do
      expect(chef_run).to create_directory('/etc/monit/conf.d')
    end
  end

  it 'enables the service' do
    expect(chef_run).to enable_service('monit')
  end

  it 'starts the service' do
    expect(chef_run).to start_service('monit')
  end

  it 'creates the global config' do
    expect(chef_run).to create_template('/etc/monitrc').with(
      :owner => 'root',
      :group => 'root',
      :mode  => '0600',
    )
  end

  # TODO: sort out stubbing the file existence to test that
  # monit::config creates /etc/default/monit when it should
  it 'does not un-disable the serviceby default' do
    expect(chef_run).to_not create_template('/etc/default/monit')
  end

  it 'creates the includes path' do
    expect(chef_run).to create_directory('/etc/monit.d')
  end

  it 'reloads the service' do
    expect(global_conf).to notify('service[monit]').to(:restart).immediately
  end
end
