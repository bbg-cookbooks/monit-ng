require 'spec_helper'

describe service('monit') do
  it { should be_enabled }
  it { should be_running }
end

describe port('2812') do
  it { should be_listening }
end
