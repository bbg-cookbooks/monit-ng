require 'spec_helper'

describe 'monit-ng::reload' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  let(:notify_block) { chef_run.ruby_block('notify-conditional-monit-reload') }

  it 'sets up the conditional reload' do
    expect(chef_run).to_not run_ruby_block('conditional-monit-reload')
  end

  it 'notifies the resource scanner' do
    expect(chef_run).to run_ruby_block('notify-conditional-monit-reload')
    expect(notify_block).to notify('ruby_block[conditional-monit-reload]').to(:run).delayed
  end
end
