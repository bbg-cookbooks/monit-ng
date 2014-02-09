require 'spec_helper'

describe 'monit::sshd' do
  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['monit_check'])
    .converge(described_recipe)
  end

  it 'installs the sshd check' do
    expect(chef_run).to install_monit_check('sshd')
  end

  it 'installs the sshd check in the correct path' do
    expect(chef_run).to create_template('monit-check')
    .with(
      path: '/etc/monit.d/sshd.conf'
    )
  end
end
