monit
=====

monit cookbook for chef

LWRP
----

```monit_d 'nginx' do
  service_type "process"
  service_id "/var/run/nginx.pid"
  service_group "nginx"
  start_command "/etc/init.d/nginx start"
  stop_command "/etc/init.d/nginx stop"
  service_tests [{'condition' => "if 3 restarts within 5 cycles", 'action' => "alert"}]
end
```
