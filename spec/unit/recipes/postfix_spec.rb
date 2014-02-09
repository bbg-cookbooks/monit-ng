require 'spec_helper'

describe 'monit::postfix' do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['monit_check'])
    .converge(described_recipe)
  end

  it 'installs the postfix check' do
    expect(chef_run).to install_monit_check('postfix')
  end

  it 'installs the postfix check in the correct path' do
    expect(chef_run).to create_template('monit-check')
    .with(
      path: '/etc/monit.d/postfix.conf'
    )
  end
end
