require 'spec_helper'

# Enabled
describe service('monit') do
  it { should be_enabled }
end

# Running
describe command('pgrep -f monit') do
  it { should return_exit_status 0 }
end

# Listening
describe port('2812') do
  it { should be_listening }
end
