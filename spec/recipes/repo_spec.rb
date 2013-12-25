require_relative '../spec_helper'

describe 'monit::repo' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'ubuntu' do
    let(:chef_run) { ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04').converge(described_recipe) }

    it 'includes the ubuntu recipe' do
      chef_run.should include_recipe 'ubuntu::default'
    end
  end

  context 'rhel' do
    let(:chef_run) { ChefSpec::Runner.new(:platform => 'centos', :version => '6.4').converge(described_recipe) }

    it 'includes yum::epel' do
      chef_run.should include_recipe 'yum-epel::default'
    end
  end

  it 'installs monit' do
    expect(chef_run).to install_package('monit')
  end

  it 'includes monit::config' do
    expect(chef_run).to include_recipe 'monit::config'
  end
end
