site :opscode

metadata

cookbook 'yum', '< 3.0'
cookbook 'ubuntu'
cookbook 'apt'
cookbook 'build-essential'

group :integration do
  cookbook 'setup', path: 'test/fixtures/cookbooks/setup'
end
