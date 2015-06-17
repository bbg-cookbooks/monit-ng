require 'spec_helper'

describe 'monit-ng::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  %w( install configure service reload ).each do |r|
    it "includes the #{r} recipe" do
      expect(chef_run).to include_recipe "monit-ng::#{r}"
    end
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end
end
