require 'spec_helper'

describe service('monit') do
  it { should be_enabled }
end

describe command('monit status') do
  its(:stdout) { should match /uptime/ }
end

describe port('2812') do
  it { should be_listening }
end
