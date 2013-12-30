require 'spec_helper'

describe 'monit::config' do
  let (:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let (:global_conf) { chef_run.template('/etc/monitrc') }

  it 'creates the includes path' do
    expect(chef_run).to create_directory('/etc/monit.d')
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
    expect(global_conf).to notify('service[monit]').to(:reload).immediately
  end
end
