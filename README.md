# Chef monit cookbook  [![Build Status](https://travis-ci.org/bbg-cookbooks/monit-ng.svg?branch=master)][travis]

Installs and configures [Monit][tildeslash], with a resource provider for managing
additional monit checks.

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

## Resources

### monit_check

|Attribute|Description|Default|
|---------|-----------|-------|
|cookbook|||
|check_type|||
|check_id|||
|id_type|||
|start_as|||
|start_as_group|||
|start|||
|stop_as|||
|stop_as_group|||
|stop|||
|group|||
|tests|||
|every|||
|alert|||
|but_not_on|||
|alert_events|||

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
[filters]: https://mmonit.com/monit/documentation/monit.html#Setting-an-event-filter
[contrib]: https://github.com/bbg-cookbooks/monit-ng/graphs/contributors
[travis]: https://travis-ci.org/bbg-cookbooks/monit-ng
