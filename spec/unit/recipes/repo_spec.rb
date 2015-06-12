require 'spec_helper'

describe 'monit-ng::repo' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  context 'rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
      .converge(described_recipe)
    end

    it 'includes yum-epel' do
      expect(chef_run).to include_recipe 'yum-epel'
    end

    it 'installs monit' do
      expect(chef_run).to install_yum_package 'monit'
    end
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
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

    it 'installs monit' do
      expect(chef_run).to install_apt_package 'monit'
    end
  end

  it 'installs monit' do
    expect(chef_run).to install_package('monit')
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end
end
