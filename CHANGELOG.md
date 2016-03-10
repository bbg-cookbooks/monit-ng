# 2.3.0 / 2016-03-09

* add ubuntu 16.04 support (thanks @micred!)
* allow array as group attribute (thanks @smt116!)
* allow specifying check mode (active,passive,manual) (thanks @yaniv-cb4!)
* specify pidfile in monitrc (thanks @tarcinil!)

# 2.2.1 / 2016-01-08

* using timeout and as-user, specify as-user first (thanks @dansteen!)

# 2.2.0 / 2015-10-21

* add start/stop timeouts

# 2.1.0 / 2015-09-01

* run syntax check before starting monit via upstart (thanks @helgi!)
* have upstart run post-start script to wait for monit to become available (thanks @helgi!)

# 2.0.3 / 2015-08-25

* skip package autostart on install (thanks @helgi!)

# 2.0.2 / 2015-07-14

* add attribute to skip service actions

# 2.0.1 / 2015-07-02

* add "depends" attribute (thanks @kcd83!)
* allow nil to disable listen address specification (thanks @kcd83!)

# 2.0.0 / 2015-06-17

* consolidate repo/source recipe into "install" recipe
* move service management into separate recipe
* remove the common-service recipes
* testing and documentation improvements

# 1.8.1 / 2015-06-14

* fix backwards compatibility with "subscriptions"

# 1.8.0 / 2015-06-11

# update to latest monit release: 5.14
* better version comparison for old SSL bug
* fix check_id attribute to support check_type "system". thanks @jorhett!
* update proactive reload ruby_block naming for clarity
* permit disabling proactive reloads

# 1.7.0 / 2015-06-05

* add alert, but_not_on, alert_events attributes for per-check alert event control (thanks @cpakman!)

# 1.6.4 / 2015-05-15

* fix upstart service name for postfix (thanks @szymonpk!)
* use verify attribute on control file templates when using Chef >= 12

# 1.6.3 / 2015-05-06

* update to latest monit release

# 1.6.2 / 2015-04-16

* start monit service later to enable chef run to cleanup busted LWRP includes that cause service start failures (thanks @vkhatri!)

# 1.6.1 / 2015-03-26

* bugfix: correct stop_as/stop_as_group var map for check template (thanks @mattadair!)

1.6.0 / 2015-03-23

* adding gid support for start_as and stop_as (start_as_group, stop_as_group attributes) (thanks @mattadair!)
* update to version 5.12.2

1.5.2 / 2015-03-15

* add stop_as support

1.5.1 / 2015-03-09

* update to latest monit version

1.5.0 / 2015-03-02

Features/Fixes:
* use latest monit (5.12) for source install
* skip yum-epel setup on amazon linux (thanks @vkhatri!)
* enforce upcased mailserver security values (thanks @vkhatri!)
* better reflect upstream configuration defaults by not specifying default mailservers/subscribers list (thanks @vkhatri!)
* improved documentation (thanks @vkhatri!)
* update global config template to support multiple or empty mail_servers config

Known Issues:
* Monit 5.12 may segfault on some platforms when system hostname resolving fails

1.4.1 / 2015-01-04

* testing updates
* documentation updates/corrections (thanks NinjaTux!)
* add quote-wrapping of smtp username/password (thanks alappe!)
* update to monit release 5.11

1.4.0 / 2014-11-04

* updated to monit 5.10 for source-install
* better support for multiple init systems
* improved support for reloading service if monit_check resources updated during the run

1.3.1 / 2014-10-29

* update bundle and fix up foodcritic, rubocop, chefspec
* add chefspec coverage reporting to list uncovered resources
* move service provider selection into attributes to facilitate wrapper cookbooks choosing preference

1.3.0 / 2014-10-29

* consolidate suite runlist into setup
* bugfix: correct service check start/stop commands under systemd
* bugfix: fix duplicate service notifications from monit_check resources
* remove snmpd recipe
* update the setup recipe to: install all needed services, set up non-pid-having services under systemd to have a pid, include all core-service recipes
* expand integration testing to cover all core-service checks, rootfs check

1.2.1 / 2014-10-23

* tidies up 1.2.0, simplifies service provider selection, fixes foodcritic warnings

1.2.0 / 2014-10-23

* update source package to 5.9
* prefer upstart init on ubuntu >= 12.04
* prefer systemd init on centos >= 7.0
* unwind sysv init on upstart/systemd platforms to help migrate from pre-1.2.0 cookbook (to be removed in 1.3)
* spec updates for serverspec 2.0
* bug-fix: correct LSB headers in sysv script to fix debian support
* add debian to test platforms
* use cookbook_name when loading our own recipes

1.1.5 / 2014-10-11

* update check_pairs to support multiple id_types for a check (thanks @vkhatri!)
* add `matching` id_type for process checks (thanks @vkhatri!)

1.1.4 / 2014-09-10

* add start config for /etc/default/monit in Ubuntu 14.04 (thanks @kevit!)

1.1.3 / 2014-09-05

* update source install to 5.8.1

1.1.2 / 2014-09-05

* rename to monit-ng

1.1.0 / 2014-04-26

* fix default overriding instance args

1.0.2 / 2014-04-26

* code cleanup
* cleaner attributes

1.0.0 / 2014-04-25

* release version 1.0.0
