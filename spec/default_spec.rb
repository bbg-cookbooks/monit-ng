require 'chefspec'

describe 'monit::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'monit::default' }

  it "builds from source when specified" do
    chef_run.node.set['monit']['install_method'] = 'source'
    expect(chef_run).to include_recipe 'monit::source'
  end

  context "configured to install by package" do
    context "in a redhat-based platform" do
      let(:redhat) do
        ChefSpec::ChefRunner.new(
          'platform' => 'redhat',
          'platform_version' => '6.4'
        )
      end
      let(:redhat_run) do
        redhat.converge 'monit::default'
      end
      it "includes the yum::epel recipe" do
        redhat.node.set['monit']['install_method'] = 'repo'
        expect(redhat_run).to include_recipe 'yum::epel'
      end
    end

    it "installs the package" do
      expect(chef_run).to install_package 'monit'
    end
  end
end

describe 'monit::common' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'monit::common' }

  it "enables the service" do
    expect(chef_run).to enable_service 'monit'
  end

  it "starts the service" do
    expect(chef_run).to start_service 'monit'
  end

  it "configures the global rc" do
    chef_run.node.set['monit']['install_method'] = 'repo'
    chef_run.node.set['monit']['conf_file'] = '/etc/monit.conf'
    expect(chef_run).to create_file '/etc/monit.conf'
    file = chef_run.template('/etc/monit.conf')
    expect(file).to_be_owned_by('root', 'root')
    expect(file.mode).to eq('0600')
  end

  it "reloads monit service" do
    notifying_resource = chef_run.template('/etc/monit.conf')
    expect(notifying_resource).to notify 'service[monit]', :reload
  end
end
