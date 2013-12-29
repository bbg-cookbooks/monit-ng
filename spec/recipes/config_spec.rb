require_relative '../spec_helper'

describe 'monit::config' do
  let (:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let (:global_conf) { chef_run.template('/etc/monitrc') }

  it 'creates the includes path' do
    expect(chef_run).to create_directory('/etc/monit.d')
  end

  context 'ubuntu_10' do
    let(:chef_run) do
      ChefSpec::Runner.new(:platform => 'ubuntu', :version => '10.04').converge(described_recipe)
    end

    it 'enables monit on Ubuntu 10' do
      expect(chef_run).to create_template('/etc/default/monit').with(
        owner: 'root',
        group: 'root',
        mode: '0600'
      )
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
      owner: 'root',
      group: 'root',
      mode: '0600'
    )
  end

  it 'reloads the service' do
    expect(global_conf).to notify('service[monit]').to(:reload).delayed
  end
end
