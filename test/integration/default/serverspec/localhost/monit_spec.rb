require 'spec_helper'

describe service('monit') do
  it { should be_enabled }
end

# Ubuntu 10 is... special
describe command('pgrep -f monit') do
  it { should return_exit_status 0 }
end

describe port('2812') do
  it { should be_listening }
end
