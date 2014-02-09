require 'spec_helper'

describe 'monit::crond' do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['monit_check'])
    .converge(described_recipe)
  end

  it 'installs the cron check' do
    expect(chef_run).to install_monit_check('crond')
  end

  it 'installs the cron check in the correct path' do
    expect(chef_run).to create_template('monit-check')
    .with(
      path: '/etc/monit.d/crond.conf'
    )
  end
end
