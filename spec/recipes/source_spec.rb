require_relative '../spec_helper'

describe 'monit::source' do
  let(:chef_run) { ChefSpec::Runner.new }

  context 'rhel' do
    let (:chef_run) { ChefSpec::Runner.new(:platform => 'centos', :version => '6.4').converge(described_recipe) }

    it 'includes the build-essential recipe' do
      expect(chef_run).to include_recipe('build-essential::default')
    end

    it 'installs build dependencies' do
      expect(chef_run).to install_package('pam-devel')
      expect(chef_run).to install_package('openssl-devel')
    end
  end

  context 'ubuntu' do
    let (:chef_run) { ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04').converge(described_recipe) }

    it 'includes the build-essential recipe' do
      expect(chef_run).to include_recipe('build-essential::default')
    end

    it 'installs build dependencies' do
      expect(chef_run).to install_package('libpam0g-dev')
      expect(chef_run).to install_package('libssl-dev')
    end
  end
end
