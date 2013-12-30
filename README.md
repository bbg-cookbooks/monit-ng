Chef monit cookbook
===================
Installs and configures monit.

Also exposes an LWRP for adding and managing additional monit control files.

Attributes
----------
- `node['monit']['config']['poll_freq']` - controls polling frequency
- `node['monit']['config']['mail_servers']` - specify mail servers to use
- `node['monit']['config']['subscribers']` - controls alert recipients
- `node['monit']['config']['mail_from']` - controls alert email from address
- `node['monit']['config']['mail_subject']` - controls alert email subject
- `node['monit']['config']['mail_message']` - controls alert email message
- `node['monit']['config']['mmonit_url']` - controls the M/Monit server
- and more!

Check attributes for the full list.

Usage
-----
#### Attributes
```ruby
default_attributes(
  'monit' => {
    'config' => {
      'poll_freq' => 30,
      'subscribers' => %w{root@localhost hostmaster@foo.net},
      'mmonit_url' => 'http://user:pass@mmonit.foo.net:8080/collector',
      'allow' => %w{localhost mmonit.foo.net}
      }
    }
  }
)
```

#### LWRP

Attributes
----------
  TODO

Examples
--------

##### External Service Check

```ruby
monit_check 'facebook_api' do
  check_type  'host'
  check_id    'api.facebook.com'
  group       'external'
  tests [
    {
      'condition' => 'failed port 80 proto http',
      'action'    => 'alert'
    },
    {
      'condition' => 'failed port 443 type tcpSSL proto http',
      'action'    => 'alert'
    },
  ]
end
```

##### SSHD

```ruby
monit_check 'sshd' do
  check_id  '/var/run/sshd.pid'
  group     'system'
  start     '/etc/init.d/ssh start'
  stop      '/etc/init.d/ssh stop'
  tests [
    {
      'condition' => "failed port #{node.openssh.server.port} proto ssh for 3 cycles",
      'action'    => 'restart'
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'alert'
    },
  ]
end
```

##### Postfix

```ruby
monit_check 'postfix' do
  check_id  '/var/spool/postfix/pid/master.pid'
  group     'system'
  start     '/etc/init.d/postfix start'
  stop      '/etc/init.d/postfix stop'
  tests [
    {
      'condition' => 'failed port 25 proto smtp',
      'action'    => 'restart'
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'alert'
    },
  ]
end
```

##### Nginx

```ruby
monit_check 'nginx' do
  check_id  '/var/run/nginx.pid'
  group     'app'
  start     '/etc/init.d/nginx start'
  stop      '/etc/init.d/nginx stop'
  tests [
    {
      'condition' => 'failed port 80',
      'action'    => 'restart'
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'alert'
    }
  ]
end
```

##### Memcache

```ruby
monit_check 'memcache' do
  check_id  '/var/run/memcached.pid'
  group     'app'
  start     '/etc/init.d/memcached start'
  stop      '/etc/init.d/memcached stop'
  tests [
    {
      'condition' => 'failed port 11211 proto memcache',
      'action'    => 'restart'
    },
    {
      'condition' => '3 restarts within 15 cycles',
      'action'    => 'alert'
    },
  ]
end
```

##### Redis

```ruby
monit_check 'redis' do
  check_id  '/var/run/redis/redis-server.pid'
  group     'database'
  start     '/etc/init.d/redis-server start'
  stop      '/etc/init.d/redis-server stop'
  tests [
    {
      'condition' => 'failed host 127.0.0.1 port 6379 
                     send "SET MONIT-TEST value\r\n" expect "OK" 
                     send "EXISTS MONIT-TEST\r\n" expect ":1"',
      'action'    => 'restart'
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'alert'
    },
  ]
end
```
##### Solr

```ruby
monit_check 'solr' do
  check_id  '/var/run/tomcat6.pid'
  group     'app'
  start     '/etc/init.d/tomcat6 start'
  stop      '/etc/init.d/tomcat6 stop'
  tests [
    {
      'condition' => 'failed port 8080 proto http and request "/solr/admin/ping" for 2 cycles',
      'action'    => 'restart'
    },
    {
      'condition' => '3 restarts within 5 cycles',
      'action'    => 'timeout'
    },
  ]
end
```

##### MongoDB

```ruby
monit_check 'mongo' do
  check_id  "#{node.mongodb.dbpath}/mongod.lock"
  group     'database'
  start     '/etc/init.d/mongodb start'
  stop      '/etc/init.d/mongodb stop'
  tests [
    {
      'condition' => "failed port #{node.mongodb.port} proto http for 2 cycles",
      'action'    => 'restart with timeout 60 seconds'
    },
    {
      'condition' => 'if 3 restarts within 10 cycles',
      'action'    => 'timeout'
    },
  ]
end
```
