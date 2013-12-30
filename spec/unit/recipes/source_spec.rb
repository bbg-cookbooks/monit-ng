require 'spec_helper'

describe 'monit::source' do
  let(:chef_run) do
    ChefSpec::Runner.new(:platform => 'centos', :version => '6.4')
    .converge(described_recipe)
  end

  it 'includes the build-essential recipe' do
    expect(chef_run).to include_recipe('build-essential::default')
  end

  it "installs build dependencies" do
    %w{pam-devel openssl-devel flex bison gcc gcc-c++ make kernel-devel}.each do |dep|
      expect(chef_run).to install_package(dep)
    end
  end

  it "downloads the source archive" do
    expect(chef_run).to create_remote_file('/var/chef/cache/monit-5.6.tar.gz')
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

    it "installs build dependencies" do
      %w{libpam0g-dev libssl-dev autoconf flex bison build-essential}.each do |dep|
        expect(chef_run).to install_package(dep)
      end
    end
  end

  it 'extracts the source archive' do
    expect(chef_run).to run_execute('extract-source-archive')
  end

  it 'compiles the sources' do
    expect(chef_run).to run_execute('compile-source')
  end

  it 'creates the init script' do
    chef_run.node.set['monit']['install_method'] = 'source'
    expect(chef_run).to create_template('/etc/init.d/monit').with(
      owner: 'root',
      group: 'root',
      mode: '0755'
    )
  end
end
