require 'spec_helper'

describe 'monit::rsyslog' do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['monit_check'])
    .converge(described_recipe)
  end

  it 'installs the rsyslog check' do
    expect(chef_run).to install_monit_check('rsyslog')
  end

  it 'installs the rsyslog check in the correct path' do
    expect(chef_run).to create_template('monit-check')
    .with(
      path: '/etc/monit.d/rsyslog.conf'
    )
  end
end
