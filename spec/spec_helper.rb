require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.before(:suite) do
    ChefSpec::Coverage.filters << File.join(config.cookbook_path, 'monit')
  end
end

at_exit { ChefSpec::Coverage.report! }
