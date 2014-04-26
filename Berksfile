source "http://api.berkshelf.com"

metadata

cookbook 'yum-epel'
cookbook 'ubuntu', '<= 1.1.4'
cookbook 'apt'
cookbook 'build-essential'

group :integration do
  cookbook 'setup', path: 'test/fixtures/cookbooks/setup'
end
