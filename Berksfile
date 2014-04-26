source "http://api.berkshelf.com"

metadata

cookbook 'yum-epel'
cookbook 'ubuntu'
cookbook 'apt'
cookbook 'build-essential'

group :integration do
  cookbook 'setup', path: 'test/fixtures/cookbooks/setup'
end
