require 'spec_helper'

describe 'monit-ng::install' do
  context 'repo install' do
    let(:repo_install) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'installs monit' do
      expect(repo_install).to install_package('monit')
    end

    it 'does not raise an exception' do
      expect { repo_install }.to_not raise_error
    end

    context 'rhel' do
      let(:repo_install) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
        .converge(described_recipe)
      end

      it 'includes yum-epel' do
        expect(repo_install).to include_recipe 'yum-epel'
      end

      it 'installs monit' do
        expect(repo_install).to install_package 'monit'
      end
    end

    context 'ubuntu' do
      let(:repo_install) do
        ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
        .converge(described_recipe)
      end

      it 'includes the apt recipe' do
        expect(repo_install).to include_recipe 'apt::default'
      end

      it 'includes the ubuntu recipe' do
        expect(repo_install).to include_recipe 'ubuntu::default'
      end

      it 'fixes the sources' do
        expect(repo_install).to create_template('/etc/apt/sources.list')
      end

      it 'installs monit' do
        expect(repo_install).to install_package 'monit'
      end
    end
  end

  context 'source install' do
    let(:source_install) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
        node.normal['monit']['install_method'] = 'source'
      end.converge(described_recipe)
    end

    let(:remote_file) do
      source_install.remote_file('/var/chef/cache/monit-5.14.tar.gz')
    end

    let(:download) { source_install.remote_file('source-archive') }

    let(:extraction) { source_install.execute('extract-source-archive') }

    let(:compilation) { source_install.execute('compile-source') }

    let(:init) { source_install.template('monit-init') }

    it 'includes the build-essential recipe' do
      expect(source_install).to include_recipe('build-essential::default')
    end

    %w( pam-devel openssl-devel ).each do |p|
      it "installs build dep: #{p}" do
        expect(source_install).to install_package(p)
      end
    end

    context 'ubuntu' do
      let(:source_install) do
        ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
          node.normal['monit']['install_method'] = 'source'
        end.converge(described_recipe)
      end

      it 'includes the apt recipe' do
        expect(source_install).to include_recipe('apt::default')
      end

      it 'includes the build-essential recipe' do
        expect(source_install).to include_recipe('build-essential::default')
      end

      %w( libpam0g-dev libssl-dev ).each do |dep|
        it "installs build dependency: #{dep}" do
          expect(source_install).to install_package(dep)
        end
      end

      it 'links source config to platform config' do
        expect(source_install).to create_link('/etc/monitrc')
        .with(to: '/etc/monit/monitrc')
      end

      it 'configures an upstart template' do
        expect(source_install).to create_template('monit-init').with(
          path: '/etc/init/monit.conf',
          mode: '0644',
        )
      end
    end

    it 'skips extraction by default' do
      expect(source_install).to_not run_execute('extract-source-archive')
    end

    it 'skips compilation by default' do
      expect(source_install).to_not run_execute('compile-source')
    end

    it 'downloads the source archive' do
      expect(source_install).to create_remote_file('source-archive')
    end

    it 'extracts the source archive' do
      expect(download).to notify('execute[extract-source-archive]')
    end

    it 'compiles the sources' do
      expect(extraction).to notify('execute[compile-source]').to(:run)
    end

    context 'mystery-os' do
      let(:source_install) do
        ChefSpec::SoloRunner.new(platform: 'omnios', version: '151002')
        .converge(described_recipe)
      end

      it 'does not create the config symlink' do
        expect(source_install).to_not create_link('/etc/monitrc')
      end
    end
  end
end
