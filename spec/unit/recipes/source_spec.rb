require 'spec_helper'

describe 'monit-ng::source' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
    .converge(described_recipe)
  end

  let(:service) { chef_run.service('monit') }

  let(:remote_file) do
    chef_run.remote_file('/var/chef/cache/monit-5.9.tar.gz')
  end

  let(:download) { chef_run.remote_file('source-archive') }

  let(:extraction) { chef_run.execute('extract-source-archive') }

  let(:compilation) { chef_run.execute('compile-source') }

  let(:init) { chef_run.template('monit-init') }

  it 'includes the build-essential recipe' do
    expect(chef_run).to include_recipe('build-essential::default')
  end

  %w( pam-devel openssl-devel flex bison gcc gcc-c++ make ).each do |dep|
    it "installs build dependency: #{dep}" do
      expect(chef_run).to install_package(dep)
    end
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
      .converge(described_recipe)
    end

    it 'includes the apt recipe' do
      expect(chef_run).to include_recipe('apt::default')
    end

    it 'includes the build-essential recipe' do
      expect(chef_run).to include_recipe('build-essential::default')
    end

    %w( libpam0g-dev libssl-dev autoconf flex bison ).each do |dep|
      it "installs build dependency: #{dep}" do
        expect(chef_run).to install_package(dep)
      end
    end

    it 'links source config to platform config' do
      expect(chef_run).to create_link('/etc/monitrc')
      .with(to: '/etc/monit/monitrc')
    end

    it 'configures an upstart template' do
      expect(chef_run).to create_template('monit-init').with(
        path: '/etc/init/monit.conf',
        mode: '0644',
      )
    end
  end

  it 'skips extraction by default' do
    expect(chef_run).to_not run_execute('extract-source-archive')
  end

  it 'skips compilation by default' do
    expect(chef_run).to_not run_execute('compile-source')
  end

  it 'downloads the source archive' do
    expect(chef_run).to create_remote_file('source-archive')
  end

  it 'extracts the source archive' do
    expect(download).to notify('execute[extract-source-archive]')
  end

  it 'compiles the sources' do
    expect(extraction).to notify('execute[compile-source]').to(:run)
  end

  it 'creates the config symlink' do
    expect(chef_run).to create_link('/etc/monitrc')
    .with(to: '/etc/monit.conf')
  end

  context 'mystery-os' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'omnios', version: '151002')
      .converge(described_recipe)
    end

    it 'does not create the config symlink' do
      expect(chef_run).to_not create_link('/etc/monitrc')
    end
  end

  it 'creates the init script' do
    expect(chef_run).to create_template('monit-init').with(
      path: '/etc/init.d/monit',
      mode: '0755',
    )
  end

  context 'modern-rhel' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0')
      .converge(described_recipe)
    end

    it 'renders a systemd template' do
      expect(chef_run).to create_template('monit-init').with(
        path: '/lib/systemd/system/monit.service',
        mode: '0644',
      )
    end
  end
end
