require 'spec_helper'

describe 'monit::repo' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'rhel' do
    let(:chef_run) do
      ChefSpec::Runner.new(:platform => 'centos', :version => '6.4')
      .converge(described_recipe)
    end

    it 'includes yum-epel' do
      expect(chef_run).to include_recipe 'yum-epel'
    end
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04')
      .converge(described_recipe)
    end

    it 'includes the apt recipe' do
      expect(chef_run).to include_recipe 'apt::default'
    end

    it 'includes the ubuntu recipe' do
      expect(chef_run).to include_recipe 'ubuntu::default'
    end

    it 'fixes the sources' do
      expect(chef_run).to create_template('/etc/apt/sources.list')
    end
  end

  it 'installs monit' do
    expect(chef_run).to install_package('monit')
  end
end
