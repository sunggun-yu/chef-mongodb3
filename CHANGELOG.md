# mongodb3 Cookbook CHANGELOG

## 3.0.0
* Update the default MongoDB package version to 3.0.7
* Update README.md #8
* Make keyserver configurable and fix faraday (berkshelf version bump) #11
* Adding support for Amazon Linux and Debian 7.8 #10
* Removing support for CentOS 5 : It seems like, there is some issue on package that MongoDB provided.

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

