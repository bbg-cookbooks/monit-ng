require 'spec_helper'

describe 'monit-ng::service' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  let(:service) { chef_run.service('monit') }

  it 'subscribes to relevant templates' do
    expect(service).to subscribe_to('template[/etc/default/monit]')
    .on(:restart).delayed
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
      .converge(described_recipe)
    end

    let(:file) { ::File }

    before { allow(file).to receive(:exist?).and_return(true) }

    it 'enables the service to start' do
      expect(chef_run).to create_template('/etc/default/monit')
    end
  end

  it 'enables the monit service' do
    expect(chef_run).to enable_service('monit')
  end

  let(:notify_start) { chef_run.ruby_block('notify-start-monit') }

  it 'runs delayed start of monit service' do
    expect(chef_run).to run_ruby_block('notify-start-monit')
    expect(notify_start).to notify('service[monit]').delayed
  end
end
