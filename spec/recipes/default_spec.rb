require_relative '../spec_helper'

describe 'monit::default' do
  let (:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'includes ubuntu cookbook on ubuntu' do
    expect(:chef_run).to include_recipe 'ubuntu::default'
  end

  it 'installs monit' do
    expect(:chef_run).to install_package('monit')
  end
end
