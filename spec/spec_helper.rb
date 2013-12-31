require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.before(:suite) {
    ChefSpec::Coverage.filters << File.join(config.cookbook_path, 'monit')
  }
end

at_exit { ChefSpec::Coverage.report! }
