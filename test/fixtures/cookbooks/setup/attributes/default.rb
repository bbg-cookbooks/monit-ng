
default['monit']['config'].tap do |conf|
  conf['subscribers'] = [
    {
      'name'          => 'me@example.com',
      'subscriptions' => %w( nonexist timeout resource icmp connection ),
    },
  ]

  conf['mail_servers'] = [
    {
      :hostname => 'smtp.example.com',
      :port => 25,
      :username => 'me@example.com',
      :password => 'pa55word',
      :security => nil,
      :timeout => '30 seconds',
    },
  ]
end
