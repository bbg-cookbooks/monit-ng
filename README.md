Chef monit cookbook  [![Build Status](https://travis-ci.org/bbg-cookbooks/monit-ng.svg?branch=master)](https://travis-ci.org/bbg-cookbooks/monit-ng)
===================
Installs and configures [Monit], with a resource
provider for managing additional monit checks.

## Recipes

- `monit::default`: installs and optionally configures monit
- `monit::repo`: installs monit from a package repository
- `monit::source`: installs monit from source
- `monit::config`: configures monit
- `monit::{crond,ntpd,postfix,rsyslog,sshd}`: install common service checks


## Dependencies

- yum-epel
- ubuntu
- apt
- build-essential


## Attributes

* `default['monit']['install_method']` (default: `repo`): whether to install using repository or source, options: repo, source

* `default['monit']['configure']` (default: `true`): should we setup the global config

* `default['monit']['conf_file']` (default: `calculated`): monit configuration file

* `default['monit']['conf_dir']` (default: `calculated`): .monitrc configuration files directory

* `default['monit']['init_style']` (default: `calculated`): monit service init style

* `default['monit']['config']['mmonit_url']` (default: `nil`): mmonit url

* `default['monit']['config']['poll_freq']` (default: `60`): how often should monit poll

* `default['monit']['config']['start_delay']` (default: `5`): configure a delay before beginning polling after service start

* `default['monit']['config']['eventqueue_dir']` (default: `/var/tmp`): where to queue events if mail server unavailable

* `default['monit']['config']['eventqueue_slots']` (default: `100`): events backlog queue size

* `default['monit']['config']['log_file']` (default: `/var/log/monit.log`): monit log file location

* `default['monit']['config']['id_file']` (default: `/var/lib/monit.id`): mmonit system id file location

* `default['monit']['config']['state_file']` (default: `/var/run/monit.state`): where to save state between startups

* `default['monit']['config']['port']` (default: `2812`): monit web interface listener port

* `default['monit']['config']['listen']` (default: `127.0.0.1`): monit web interface listener address

* `default['monit']['config']['allow']` (default: `localhost`): list of permitted control port accessors (host, basic-auth, pam, htpasswd)

* `default['monit']['config']['mail_from']` (default: `node fqdn | localhost`): email notification from address

* `default['monit']['config']['mail_subject']` (default: `$SERVICE $EVENT at $DATE`): notification email subject

* `default['monit']['config']['mail_message']` (default: `text`): email notification body

* `default['monit']['config']['subscribers']` (default: `[]`): this attributes configures `set alert` config option for each `Hash` element (subscriber) with attribute `name` and `subscriptions`, e.g. chef role

	  "default_attributes": {
	    "monit": {
		  "config": {
			"subscribers": [
			  {
			    "name": "root@localhost",
			    "subscriptions": [ "nonexist", "timeout", "resource", "icmp", "connection"]
			  }
			]
		  }
		}
	  }


* `default['monit']['config']['mail_servers']` (default: `[]`): this attributes configures `set mailserver` config option for each `Hash` element (mail server) with below attributes, e.g. chef role

	  "default_attributes": {
	    "monit": {
		  "config": {
			"mail_servers": [
			  {
			  	"hostname": "localhost",
			  	"port": 25,
			  	"username": null,
			  	"password": null,
			  	"security": null,
			  	"timeout": "30 seconds"
			  }
			]
		  }
		}
	  }



## monit_check resource examples


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
      'condition' => '3 restarts within 10 cycles',
      'action'    => 'timeout'
    },
  ]
end
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Nathan Williams and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>


[Monit]: http://mmonit.com/monit/
[Contributors]: https://github.com/bbg-cookbooks/monit-ng/graphs/contributors
