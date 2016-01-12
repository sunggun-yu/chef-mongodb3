# mongodb3 Cookbook CHANGELOG

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

