require 'spec_helper'

describe 'monit::ntpd' do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['monit_check'])
    .converge(described_recipe)
  end

  it 'installs the ntp check' do
    expect(chef_run).to install_monit_check('ntpd')
  end

  it 'installs the ntp check in the correct path' do
    expect(chef_run).to create_template('monit-check')
    .with(
      path: '/etc/monit.d/ntpd.conf'
    )
  end
end
