require 'spec_helper'

# Enabled
describe service('monit') do
  it { should be_enabled }
end

# Running
describe command('/etc/init.d/monit status') do
  its(:stdout) { should match /uptime/ }
end

# Listening
describe port('2812') do
  it { should be_listening }
end
