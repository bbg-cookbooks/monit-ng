Chef monit cookbook
===================
Installs and configures monit.

Also exposes an LWRP for adding and managing additional monit control files.

Attributes
----------
- `node['monit']['config']['daemon']` - controls polling frequency
- `node['monit']['config']['mailservers']` - specify mail servers to use
- `node['monit']['config']['subscribers']` - controls alert recipients
- `node['monit']['config']['mail_from']` - controls alert email from address
- `node['monit']['config']['mail_subject']` - controls alert email subject
- `node['monit']['config']['mail_message']` - controls alert email message
- `node['monit']['config']['mmonit_host']` - controls the M/Monit server
- and more!

Check attributes/default.rb for the full list.

Usage
-----
#### Attributes
```json
{
  "monit" => {
    "config" => {
      "daemon" => 90,
      "subscribers" => ["root@localhost", "hostmaster@foo.net"],
      "mmonit_host" => "http://user:pass@mmonit.foo.net:8080/collector",
      "listen_allow" => ["localhost","mmonit.foo.net", "@users read-only"],
      }
    }
  }
}
```

#### Defaults


#### LWRP

Examples of the LWRP resource:

##### SSHD

```ruby
monit_d 'sshd' do
  service_type "process"
  service_id "/var/run/sshd.pid"
  service_group "sshd"
  start_command "/etc/init.d/ssh start"
  stop_command "/etc/init.d/ssh stop"
  service_tests [
    {'condition' => "if failed port 22 proto ssh for 3 cycles",
     'action' => "restart"},
    {'condition' => "if 3 restarts within 5 cycles",
     'action' => "alert"},
  ]
end
```

##### Postfix

```ruby
monit_d 'postfix' do
  service_type "process"
  service_id "/var/spool/postfix/pid/master.pid"
  service_group "mail"
  start_command "/etc/init.d/postfix start"
  stop_command "/etc/init.d/postfix stop"
  service_tests [
    {'condition' => "if failed host 127.0.0.1 port 25 type tcp protocol smtp with timeout 15 seconds",
     'action' => "restart"},
    {'condition' => "if 3 restarts within 5 cycles",
     'action' => "alert"},
  ]
end
```

##### Nginx

```ruby
monit_d 'nginx' do
  service_type "process"
  service_id "/var/run/nginx.pid"
  service_group "app"
  start_command "/etc/init.d/nginx start"
  stop_command "/etc/init.d/nginx stop"
  service_tests [
    {'condition' => "if failed port 80 proto http", 'action' => "restart"},
    {'condition' => "if 3 restarts within 5 cycles", 'action' => "alert"}
  ]
end
```

##### Unicorn 

```ruby
monit_d 'unicorn' do
  service_type "process"
  service_id "#{node.site.docroot}/shared/pids/unicorn.pid"
  service_group "app"
  start_command "/usr/bin/sudo -u #{node.site.app_user} /bin/bash -l -c '#{node.site.docroot}/current/bin/unicorn -c #{node.site.docroot}/current/config/unicorn.rb -E #{node.site.environment} -D'"
  stop_command "/usr/bin/pkill -f unicorn"
  service_tests [
    {'condition' => "if failed port 80 type tcp proto http",
     'action' => "restart"},
    {'condition' => "if totalmem > 1200 MB for 2 cycles",
     'action' => "alert"},
    {'condition' => "if totalmem > 1500 MB for 2 cycles",
     'action' => "restart"},
    {'condition' => "if failed unixsocket #{node.unicorn.socket} for 2 cycles",
     'action' => "restart"},
    {'condition' => "if 5 restarts within 5 cycles",
     'action' => "timeout"},
  ]
end
```

##### Memcache

```ruby
monit_d 'memcache' do
  service_type "process"
  service_id "/var/run/memcached.pid"
  service_group "memcache"
  start_command "/etc/init.d/memcached start"
  stop_command "/etc/init.d/memcached stop"
  service_tests [
    {'condition' => "if failed port 11211 proto memcache 4 times within 5 cycles",
     'action' => "restart"},
    {'condition' => "if 3 restarts within 15 cycles",
     'action' => "alert"},
  ]
end
```
##### Redis

```ruby
monit_d 'redis' do
  service_type "process"
  service_id "/var/run/redis/redis-server.pid"
  service_group "database"
  start_command "/etc/init.d/redis-server start"
  stop_command "/etc/init.d/redis-server stop"
  service_tests [
    {'condition' => 'if failed host 127.0.0.1 port 6379 
                     send "SET MONIT-TEST value\r\n" expect "OK" 
                     send "EXISTS MONIT-TEST\r\n" expect ":1"',
     'action' => 'restart'},
    {'condition' => 'if 3 restarts within 5 cycles',
     'action' => 'alert'},
  ]
end
```

#### LWRP Attributes
<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Example</th>
      <th>Default</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>name</td>
      <td>name of the `/etc/monit.d` file</td>
      <td><tt>nginx</tt></td>
      <td>current resource name</td>
    </tr>
    <tr>
      <td>service_type</td>
      <td>type of monitoring</td>
      <td><tt>process, host, file</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>service_group</td>
      <td>group related checks (e.g. nginx, unicorn are in the "app" group below)</td>
      <td><tt>app, db</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>start_command</td>
      <td>command to start a process if performing a process check</td>
      <td><tt>"/etc/init.d/nginx start"</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>stop_command</td>
      <td>command to stop a process if performing a process check</td>
      <td><tt>"/etc/init.d/nginx stop"</tt></td>
      <td></td>
    </tr>
    <tr>
      <td>service_tests</td>
      <td>free-form hash composed of a condition and an action, allows performing of monitoring tests on a wide variety of attributes</td>
      <td><tt>
             [{'condition' => "if failed port 80 type tcp proto http", 'action' => "restart"},
              {'condition' => "if totalmem > 80% for 2 cycles", 'action' => "alert"}]
          </tt>
      </td>
      <td></td>
    </tr>
  </tbody>
</table>

TODO
----
- finish source_install method
-- init script
-- install path
-- checksum
- allow more periodic checks (every)
- add subscriber opt-in/opt-outs
