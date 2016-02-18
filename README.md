# Chef monit cookbook  [![Build Status](https://travis-ci.org/bbg-cookbooks/monit-ng.svg?branch=master)][travis]

Installs and configures [Monit][tildeslash], with a resource provider for managing
additional monit checks.

Suggested background reading:

* [The Fine Manual][manual]
* This README, the resource and provider in cookbook libraries directory.

## Recipes

- `monit-ng::default`: loads the other recipes in the order below
- `monit-ng::install`: installs monit via package or source
- `monit-ng::configure`: configures global monit template
- `monit-ng::service`: configures and manages the monit service
- `monit-ng::reload`: reloads monit service if converge updated a monit_check

## Dependencies

- yum-epel (on rhel hosts)
- ubuntu (on ubuntu hosts)
- apt (on debian hosts)
- build-essential (if installing from source)


## Attributes

Most of these are very straight-forward, and pulled directly from the manual.
See the inline documentation in attributes/\*.rb for details.

The few "special" attributes are noted below:

* `default['monit']['config']['alert']` (default: `[]`): this attributes configures *global* `set alert` config option for each `Hash` element with attribute `name` and optional event filters  

Documentation for event filters can be found [here][filters].

```
"default_attributes": {
  "monit": {
    "config": {
      "alert": [
        {
			    "name": "root@localhost",
			    "but_not_on": [ "nonexist" ]
			  },
			  {
			    "name": "netadmin@localhost",
			    "only_on": [ "nonexist", "timeout", "icmp", "connection"]
			  },
			  {
			    "name": "iwantall@localhost",
			  }
			]
    }
  }
}
```

* `default['monit']['config']['mail_servers']` (default: `[]`): this attributes configures `set mailserver` config option for each `Hash` element (mail server) with hash like so:

```
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
```


* `default['monit']['config']['built_in_configs']` (default: `[]`): this defines what built-in configuration files will be included

```
"default_attributes": {
  "monit": {
    "config": {
      "built_in_configs": [
        "memcached",
        "nginx"
      ]
    }
  }
}
```

## Resources

### monit_check

|Attribute|Description|Default|
|---------|-----------|-------|
|cookbook|cookbook from which to source monit config template|monit-ng|
|check_type|type of check (e.g. program, process, host)|process|
|check_id|check identifier (e.g. pid path, hostname, executable path|nil|
|id_type|type of identifier (e.g. pid, matching, address, path)|determined by check_type|
|start_as|user to execute start command as|nil|
|start_as_group|group to start program as|nil|
|start|start command|nil|
|stop_as|user to execute stop command as|nil|
|stop_as_group|group to execute stop command as|nil|
|stop|stop command|nil|
|group|check group(s) (e.g. "hosts" or ["hosts", "apis"])|[]|
|depends|depends on named service (e.g. "apache")|nil|
|tests|array of hashes with 'condition', 'action' keys, maps to monit if, then|[]|
|every|string for args to "every" configuration (e.g. every n cycles, every "* 8-19 * * 1-5")|nil|
|alert|email to alert|nil|
|but_not_on|alert modifier to filter events for notification|nil|
|alert_events|alert modifier to filter events for notification|nil|

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

Authors:: Nathan Williams and [contributors][contrib]

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[tildeslash]: http://mmonit.com/monit/
[manual]: https://mmonit.com/monit/documentation/
[filters]: https://mmonit.com/monit/documentation/monit.html#Setting-an-event-filter
[contrib]: https://github.com/bbg-cookbooks/monit-ng/graphs/contributors
[travis]: https://travis-ci.org/bbg-cookbooks/monit-ng
