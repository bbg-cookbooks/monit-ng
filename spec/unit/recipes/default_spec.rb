require 'spec_helper'

describe 'monit-ng::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'includes the repo recipe' do
    expect(chef_run).to include_recipe 'monit-ng::repo'
  end

  # Switching context indirectly tests the build-essential cookbook
  # (i.e. if we don't set the platform, build-essential explodes)
  context 'rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.4')
    end

    it 'includes the source recipe' do
      chef_run.node.set['monit']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe 'monit-ng::source'
    end
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
    end

    it 'includes the source recipe' do
      chef_run.node.set['monit']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      expect(chef_run).to include_recipe 'monit-ng::source'
    end
  end

  it 'includes the config recipe' do
    expect(chef_run).to include_recipe 'monit-ng::config'
  end

  it 'skips the config recipe' do
    chef_run.node.set['monit']['configure'] = false
    chef_run.converge(described_recipe)
    expect(chef_run).to_not include_recipe 'monit-ng::config'
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end
end
