node.default['monit']['config']['subscribers'] = [
  {
    'name'          => 'this@localhost',
    'subscriptions' => %w( connection content data )
  },
  {
    'name'          => 'that@localhost',
    'but_not_on' => %w( nonexist )
  },
  {
    'name'          => 'theother@localhost',
    'only_on' => %w( size timeout timestamp uid ),
  },
]
