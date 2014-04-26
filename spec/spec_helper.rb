require 'chefspec'
require 'chefspec/server'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! do
  add_filter 'cookbooks/monit'
end
