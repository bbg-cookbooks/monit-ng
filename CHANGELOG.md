1.3.1

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
