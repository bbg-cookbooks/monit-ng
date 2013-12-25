require_relative '../spec_helper'

describe 'monit::default' do
  let (:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'includes the repo recipe' do
    chef_run.node.set['monit']['install_method'] = 'repo'
    chef_run.converge(described_recipe)
    expect(chef_run).to include_recipe 'monit::repo'
  end

  # Switching context indirectly tests the build-essential cookbook
  context 'rhel' do
    let (:chef_run) { ChefSpec::Runner.new(:platform => 'centos', :version => '6.4').converge(described_recipe) }

    it 'includes the source recipe' do
      chef_run.node.set['monit']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe 'monit::source'
    end
  end

  context 'ubuntu' do
    let (:chef_run) { ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04').converge(described_recipe) }

    it 'includes the source recipe' do
      chef_run.node.set['monit']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe 'monit::source'
    end
  end
end
