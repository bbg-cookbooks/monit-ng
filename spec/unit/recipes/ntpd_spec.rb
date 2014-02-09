require 'spec_helper'

describe 'monit::ntpd' do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['monit_check'])
    .converge(described_recipe)
  end

  it 'installs the ntp check' do
    expect(chef_run).to install_monit_check('ntpd')
  end
end
