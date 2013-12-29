require_relative '../spec_helper'

describe 'monit::source' do
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'centos', :version => '6.4')
    .converge(described_recipe)
  end

  it 'includes the build-essential recipe' do
    expect(chef_run).to include_recipe('build-essential::default')
  end

  it 'installs the build dependencies' do
    expect(chef_run).to install_package('pam-devel')
    expect(chef_run).to install_package('openssl-devel')
  end

  context 'ubuntu' do
    let (:chef_run) do
      ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04')
      .converge(described_recipe)
    end

    it 'includes the apt recipe' do
      expect(chef_run).to include_recipe('apt::default')
    end

    it 'includes the build-essential recipe' do
      expect(chef_run).to include_recipe('build-essential::default')
    end

    it 'installs the build dependencies' do
      expect(chef_run).to install_package('libpam0g-dev')
      expect(chef_run).to install_package('libssl-dev')
    end
  end

  it 'creates the init script' do
    expect(chef_run).to create_template('/etc/init.d/monit').with(
      owner: 'root',
      group: 'root',
      mode: '0755'
    )
  end
end
