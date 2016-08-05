# mongodb3 Cookbook CHANGELOG

## 5.3.0

Thank you so much for your huge contribution on this release!

* PR #36 : The mongos service shall be restarted to pick the new config. Jose Olcese([@jolcese](https://github.com/jolcese))
* PR #38 : Enable/Disable Transparent Huge Pages if needed. Dennis Pattmann([@dpattmann](https://github.com/dpattmann))
 * The cookbook disable the Transparent Huge Pages by default.
* PR #39 : Adding support for ubuntu 15.04 and 16.04. Marcin Skurski([@mskurski](https://github.com/mskurski))
 * Changing service provider to `Chef::Provider::Service::Systemd` for ubuntu >= 15.04
 * Fix #44
* PR #40 : Allow override of the cookbook used for mongos runit templates. Popsikle([@popsikle](https://github.com/popsikle))
* PR #41 : Create and set ownership of data directory for mms-automation-agent. Amsdard([@amsdard](https://github.com/amsdard))
* Adding support Ubuntu 15.04 and 16.04 for MMS Automation and Monitoring Agent.
* Testing in CentOS 6.8. 
 * 6.6 was missing in bento.
* No longer support Chef Client version 11.
 * Chef Client version issue related to Custom Resources
 * It is also decision for upcoming LWRP in mongodb3 cookbook.

## 5.2.0

* PR #35 : bypass dpkg errors about pre-existing init or conf file. Damien Raude-Morvan([@drazzib](https://github.com/drazzib))
* Fix #34 : Supporting all the MMS Automation/Monitoring agent configuration options.
* Updating default version of MongoDB package installation as 3.2.4

## 5.1.0

* Feature request #31 : Creating sysLog directory for mongod 
* Fixing #30 : Changing service provider as `Chef::Provider::Service::Upstart` for ubuntu 14.04

## 5.0.0

* Fixed Chef::Mixin::Template::TemplateError: Node attributes are read-only when you do not specify which precedence level to set with Chef 11.10 - Daniel Doubrovkine([@dblock](https://github.com/dblock)) #21.
* Adding test for chef client 11.18.12 as 11.x : testing for #21
* Adding kitchen test for ubuntu 14.04 : #13
* Using `/var/run/mongodb/mongod.pid` for centos7 : #25
* Moving attribute setter to recipe in order to support install 3.0.x in wrapper cookbook. : #23
* Adding the mongodb 3.0.x version testing in test wrapper cookbook : #23
* Adding key file directory creation
* Fixing for yum and apt repo name
* Update default version as 3.2.1 : #24

## 4.0.0

Thank you so much for your contribution!

* Allowed overrides of mongo repo name for debian/ubuntu packages - Dave Augustus([@daugustus](https://github.com/daugustus))
* Added support for MongoDB 3.2.0 - Constantin Guay([@Cog-g](https://github.com/Cog-g))
* Support for both MongoDB 3.0.x and 3.2.x - Julien Pervillé([@jperville](https://github.com/jperville))

## 3.0.0
* Update the default MongoDB package version to 3.0.7
* Update README.md #8
* Make keyserver configurable and fix faraday (berkshelf version bump) #11
* Adding support for Amazon Linux and Debian 7.8 #10
* Removing support for CentOS 5 : It seems like, there is some issue on package that MongoDB provided.
* Removing kitchen test of mongos for oel-6.6 : There was no 3.0.7-1.el6 of mongos package for Oracle Linux 6.6 (Test failure). I'll keep testing and bring it back later.

NOTICE :

* Current version 3.0.0 is not supporting mongos 3.0.7 for Oracle Linux 6.6. The package version 3.0.7-1.el6 of mongodb-org-shell package wasn't existing (Test failure).
* Current version 3.0.0 is not supporting automation and monitoring mms agent installation for Debian 7.8

## 2.0.0

WARNING : `mms-agent` recipe has been deprecated at this version.

* Removing `mongodb-org` package installation : `mongodb-org` package installs latest version of mongodb modules such as `mongodb-org-server`. so that installing lower version of mongodb-org-server has been failed.
* Removing `mms-agent` recipe and divide it as `mms-automation-agent` and `mms-monitoring-agent` recipe
* PR #3 : Bump up the runit dependency version to 1.7.0. Thank you for your contribution @dherges

## 1.0.0

mongodb3 Chef Cookbook 1.0.0 release.

## 0.2.0

Bug fixes.

## 0.1.0

Initial release of mongodb3

