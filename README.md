# mongodb3 cookbook

[![Build Status](https://travis-ci.org/sunggun-yu/chef-mongodb3.svg?branch=master)](https://travis-ci.org/sunggun-yu/chef-mongodb3)

## Install and configure the MongoDB 3

* Install and configure the mongod (or configure the config server for shard cluster)
* Install and configure the mongos
 * Also, mongos configure the mongos service with runit : `service mongos start|stop|restart|status` 
* Install and configure the MMS Automation Agent
* Install and configure the MMS Monitoring Agent

### NOTICE :

* Current version is not supporting automation and monitoring mms agent installation for Debian 7.8.
* MongoDB **3.2.8** is default version of mongodb3 cookbook.
* Mongodb3 cookbook is **NO LONGER SUPPORT** Chef Client version 11.

### Contributors

* David Herges - [@dherges](https://github.com/dherges)
* Joe Passavanti - [@gottaloveit](https://github.com/gottaloveit)
* MEGA MOnolithic meTHod - [@megamoth](https://github.com/megamoth)
* Dave Augustus - [@daugustus](https://github.com/daugustus)
* Constantin Guay - [@Cog-g](https://github.com/Cog-g)
* Julien Pervillé - [@jperville](https://github.com/jperville)
* Daniel Doubrov - [@dblock](https://github.com/dblock)
* Damien Raude-Morvan - [@drazzib](https://github.com/drazzib)
* Jose Olcese - [@jolcese](https://github.com/jolcese)
* Dennis Pattmann - [@dpattmann](https://github.com/dpattmann)
* Marcin Skurski - [@mskurski](https://github.com/mskurski)
* Popsikle - [@popsikle](https://github.com/popsikle)
* Amsdard - [@amsdard](https://github.com/amsdard)

## Supported Platforms

The following platforms have been tested with Test Kitchen

* Ubuntu 12.04, 14.04, 15.04, 16.04
* Debian 7.8
* CentOS 6.8, 7.2
* Oralce 6.6
* Amazon Linux

## Attributes

### Cookbook Attributes
mongodb3 cookbook uses the package installation of mongodb3 such as yum or apt. and these attributes are used for setting default values in order to provide the correct installation of mongodb3. typically, you can modify cookbook attributes if you need. however, I do not recommend to modify these attributes if you want to use package that is provided from MongoDB.

WARNING : Please do not set the user and group attribute on your side. This cook book let installing user and group by mongodb package (except `mongos` and `mms-monitoring-agent` recipe). The user and group name will be set by condition in default attribute because mongodb package installs different user and group name by platform.

```
# MongoDB version to install
default['mongodb3']['version'] = '3.2.1'
default['mongodb3']['package']['version'] = Actual package version to install. It builds from version attribute.

# Package repository url
default['mongodb3']['package']['repo']['url'] = Package repository url

# Attribute for apt_repository
default['mongodb3']['package']['repo']['apt']['name'] = nil  # eg. 3.0, 3.2
default['mongodb3']['package']['repo']['apt']['keyserver'] = nil # eg. hkp://keyserver.ubuntu.com:80
default['mongodb3']['package']['repo']['apt']['key'] = nil # eg. 3.2 : 'EA312927', 3.0 : '7F0CEB10'
default['mongodb3']['package']['repo']['apt']['components'] = nil # `multiverse` for ubuntu. `main` for debian

# MongoDB user:group : PLEASE DO NOT SET THE USER AND GROUP ATTRIBUTE
default['mongodb3']['user'] = 'mongod' | 'mongodb'
default['mongodb3']['group'] = 'mongod' | 'mongodb'

# Mongod config file path
default['mongodb3']['mongod']['config_file'] = '/etc/mongod.conf'

# Mongos config file path
default['mongodb3']['mongos']['config_file'] = '/etc/mongos.conf'

# Runit template cookbook for mongos
default['mongodb3']['mongos']['runit_template_cookbook'] = 'mongodb3'

# Key file contents
default['mongodb3']['config']['key_file_content'] = nil
```

### Mongod config Attributes

* The default value of the attribute is referred to the MongoDB documentation.
* The `nil` value attribute will be ignored for mongod config file.
* This cookbook fills nil for some of the attribute value to concise initial mongod config file.
* Also, deprecated attributed is not included.

#### systemLog Options

http://docs.mongodb.org/manual/reference/configuration-options/#systemlog-options

```
default['mongodb3']['config']['mongod']['systemLog']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['quiet'] = nil # default : false
default['mongodb3']['config']['mongod']['systemLog']['traceAllException'] = nil # default : false
default['mongodb3']['config']['mongod']['systemLog']['syslogFacility'] = nil # default : 'user'
default['mongodb3']['config']['mongod']['systemLog']['path'] = '/var/log/mongodb/mongod.log'
default['mongodb3']['config']['mongod']['systemLog']['logAppend'] = true # default : false
default['mongodb3']['config']['mongod']['systemLog']['logRotate'] = nil # default : 'rename'
default['mongodb3']['config']['mongod']['systemLog']['destination'] = 'file' # default : 'file'
default['mongodb3']['config']['mongod']['systemLog']['timeStampFormat'] = nil # default : 'iso8601-local'
```

#### systemLog.component Options

http://docs.mongodb.org/manual/reference/configuration-options/#systemlog-component-options

```
default['mongodb3']['config']['mongod']['systemLog']['component']['accessControl']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['command']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['control']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['geo']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['index']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['network']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['query']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['replication']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['sharding']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['storage']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['storage']['journal']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['component']['write']['verbosity'] = nil # default : 0
```

#### processManagement Options

http://docs.mongodb.org/manual/reference/configuration-options/#processmanagement-options

```
default['mongodb3']['config']['mongod']['processManagement']['fork'] = true or nil # default : false
default['mongodb3']['config']['mongod']['processManagement']['pidFilePath'] = '/var/run/mongodb/mongodb.pid' or nil
```

#### net Options

http://docs.mongodb.org/manual/reference/configuration-options/#net-options

```
default['mongodb3']['config']['mongod']['net']['port'] = 27017
default['mongodb3']['config']['mongod']['net']['bindIp'] = nil # default : '0.0.0.0'
default['mongodb3']['config']['mongod']['net']['maxIncomingConnections'] = nil # default : 65536
default['mongodb3']['config']['mongod']['net']['wireObjectCheck'] = nil # default : true
default['mongodb3']['config']['mongod']['net']['ipv6'] = nil # default : false
```

#### net.unixDomainSocket Options

http://docs.mongodb.org/manual/reference/configuration-options/#net-unixdomainsocket-options

```
default['mongodb3']['config']['mongod']['net']['unixDomainSocket']['enabled'] = nil # default : true
default['mongodb3']['config']['mongod']['net']['unixDomainSocket']['pathPrefix'] = nil # default : '/tmp'
default['mongodb3']['config']['mongod']['net']['unixDomainSocket']['filePermissions'] = nil # default : '0700'
```

#### net.http Options

http://docs.mongodb.org/manual/reference/configuration-options/#net-http-options

```
default['mongodb3']['config']['mongod']['net']['http']['enabled'] = nil # default : false
default['mongodb3']['config']['mongod']['net']['http']['JSONPEnabled'] = nil # default : false
default['mongodb3']['config']['mongod']['net']['http']['RESTInterfaceEnabled'] = nil # default : false
```

#### net.ssl Options

http://docs.mongodb.org/manual/reference/configuration-options/#net-ssl-options

```
default['mongodb3']['config']['mongod']['net']['ssl']['mode'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['PEMKeyFile'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['PEMKeyPassword'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['clusterFile'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['clusterPassword'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['CAFile'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['CRLFile'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['allowConnectionsWithoutCertificates'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['allowInvalidCertificates'] = nil
default['mongodb3']['config']['mongod']['net']['ssl']['allowInvalidHostnames'] = nil # default : false
default['mongodb3']['config']['mongod']['net']['ssl']['FIPSMode'] = nil
```

#### security Options

http://docs.mongodb.org/manual/reference/configuration-options/#security-options

```
default['mongodb3']['config']['mongod']['security']['keyFile'] = nil
default['mongodb3']['config']['mongod']['security']['clusterAuthMode'] = nil
default['mongodb3']['config']['mongod']['security']['authorization'] = 'disabled'
default['mongodb3']['config']['mongod']['security']['javascriptEnabled'] = nil # default : true
```

#### security.sasl Options

http://docs.mongodb.org/manual/reference/configuration-options/#security-sasl-options

```
default['mongodb3']['config']['mongod']['security']['sasl']['hostName'] = nil
default['mongodb3']['config']['mongod']['security']['sasl']['serviceName'] = nil
default['mongodb3']['config']['mongod']['security']['sasl']['saslauthdSocketPath'] = nil
```

#### storage Options

http://docs.mongodb.org/manual/reference/configuration-options/#storage-options

```
default['mongodb3']['config']['mongod']['storage']['dbPath'] = '/var/lib/mongo' | '/var/lib/mongodb'
default['mongodb3']['config']['mongod']['storage']['indexBuildRetry'] = nil # default : true
default['mongodb3']['config']['mongod']['storage']['repairPath'] = nil
default['mongodb3']['config']['mongod']['storage']['journal']['enabled'] = true
default['mongodb3']['config']['mongod']['storage']['directoryPerDB'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['syncPeriodSecs'] = nil # default : 60
default['mongodb3']['config']['mongod']['storage']['engine'] = 'mmapv1'
```

#### storage.mmapv1 Options

http://docs.mongodb.org/manual/reference/configuration-options/#storage-mmapv1-options

```
default['mongodb3']['config']['mongod']['storage']['mmapv1']['preallocDataFiles'] = nil # default : true
default['mongodb3']['config']['mongod']['storage']['mmapv1']['nsSize'] = nil # default : 16
default['mongodb3']['config']['mongod']['storage']['mmapv1']['quota']['enforced'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['mmapv1']['quota']['maxFilesPerDB'] = nil # default : 8
default['mongodb3']['config']['mongod']['storage']['mmapv1']['smallFiles'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['mmapv1']['journal']['debugFlags'] = nil
default['mongodb3']['config']['mongod']['storage']['mmapv1']['journal']['commitIntervalMs'] = nil # default : 100 or 30
```

#### storage.wiredTiger Options

http://docs.mongodb.org/manual/reference/configuration-options/#storage-wiredtiger-options

```
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['cacheSizeGB'] = nil
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['statisticsLogDelaySecs'] = nil # default : 0
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['journalCompressor'] = nil # default : 'snappy'
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['directoryForIndexes'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['collectionConfig']['blockCompressor'] = nil # default : 'snappy'
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['indexConfig']['prefixCompression'] = nil # default : true
```

#### operationProfiling Options

http://docs.mongodb.org/manual/reference/configuration-options/#operationprofiling-options

```
default['mongodb3']['config']['mongod']['operationProfiling']['slowOpThresholdMs'] = nil # default : 100
default['mongodb3']['config']['mongod']['operationProfiling']['mode'] = nil # default : 'off'
```

#### replication Options

http://docs.mongodb.org/manual/reference/configuration-options/#replication-options

```
default['mongodb3']['config']['mongod']['replication']['oplogSizeMB'] = nil
default['mongodb3']['config']['mongod']['replication']['replSetName'] = nil
default['mongodb3']['config']['mongod']['replication']['secondaryIndexPrefetch'] = nil # default : 'all'
```

#### sharding Options

http://docs.mongodb.org/manual/reference/configuration-options/#sharding-options

```
default['mongodb3']['config']['mongod']['sharding']['clusterRole'] = nil
default['mongodb3']['config']['mongod']['sharding']['archiveMovedChunks'] = nil # default : true
```

#### auditLog Options

http://docs.mongodb.org/manual/reference/configuration-options/#auditlog-options

```
default['mongodb3']['config']['mongod']['auditLog']['destination'] = nil
default['mongodb3']['config']['mongod']['auditLog']['format'] = nil
default['mongodb3']['config']['mongod']['auditLog']['path'] = nil
default['mongodb3']['config']['mongod']['auditLog']['filter'] = nil
```

#### snmp Options

http://docs.mongodb.org/manual/reference/configuration-options/#snmp-options

```
default['mongodb3']['config']['mongod']['snmp']['subagent'] = nil
default['mongodb3']['config']['mongod']['snmp']['master'] = nil
```

### Mongos config Attributes

#### Default config for mongos

```
default['mongodb3']['config']['mongos']['net']['port'] = 27018 # default : 27017
default['mongodb3']['config']['mongos']['net']['bindIp'] = '127.0.0.1' # default : '0.0.0.0'
default['mongodb3']['config']['mongos']['systemLog']['path'] = '/var/log/mongodb/mongos.log'
default['mongodb3']['config']['mongos']['systemLog']['logAppend'] = true # default : false
default['mongodb3']['config']['mongos']['systemLog']['destination'] = 'file' # default : 'file'
```

#### mongos-only Options

http://docs.mongodb.org/manual/reference/configuration-options/#mongos-only-options

```
default['mongodb3']['config']['mongos']['replication']['localPingThresholdMs'] = nil # default : 15
default['mongodb3']['config']['mongos']['sharding']['autoSplit'] = true # default : true
default['mongodb3']['config']['mongos']['sharding']['configDB'] = nil
default['mongodb3']['config']['mongos']['sharding']['chunkSize'] = 64 # default : 64
```

### MMS Automation/Monitoring Agent

#### Common configuration attributes for both automation and monitoring agent.
```
default['mongodb3']['config']['mms']['mmsApiKey'] = nil
default['mongodb3']['config']['mms']['mmsBaseUrl'] = 'https://api-agents.mongodb.com'
default['mongodb3']['config']['mms']['httpProxy'] = nil
default['mongodb3']['config']['mms']['krb5ConfigLocation'] = nil
default['mongodb3']['config']['mms']['sslTrustedMMSServerCertificate'] = nil
default['mongodb3']['config']['mms']['sslRequireValidMMSServerCertificates'] = nil
```

#### Attributes for automation agent.
https://docs.opsmanager.mongodb.com/current/reference/automation-agent
```
default['mongodb3']['config']['mms']['mmsGroupId'] = nil
default['mongodb3']['config']['mms']['logFile'] = '/var/log/mongodb-mms-automation/automation-agent.log'
default['mongodb3']['config']['mms']['mmsConfigBackup'] = '/var/lib/mongodb-mms-automation/mms-cluster-config-backup.json'
default['mongodb3']['config']['mms']['logLevel'] = 'INFO'
default['mongodb3']['config']['mms']['maxLogFiles'] = 10
default['mongodb3']['config']['mms']['maxLogFileSize'] = 268435456
```

#### Attributes for monitoring agent.
https://docs.opsmanager.mongodb.com/current/reference/monitoring-agent
```
default['mongodb3']['config']['mms']['useSslForAllConnections'] = nil
default['mongodb3']['config']['mms']['sslClientCertificate'] = nil
default['mongodb3']['config']['mms']['sslClientCertificatePassword'] = nil
default['mongodb3']['config']['mms']['sslTrustedServerCertificates'] = nil
default['mongodb3']['config']['mms']['sslRequireValidServerCertificates'] = nil
default['mongodb3']['config']['mms']['krb5Principal'] = nil
default['mongodb3']['config']['mms']['krb5Keytab'] = nil
default['mongodb3']['config']['mms']['gsappiServiceName'] = nil
default['mongodb3']['config']['mms']['enableMunin'] = nil
```


## Usage

### mongodb3::default

Install and configure the mongod or config server instance.

Include `mongodb3::default` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[mongodb3::default]"
  ]
}
```

### mongodb3::mongos

Install and configure the mongos.

Include `mongodb3::mongos` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[mongodb3::mongos]"
  ]
}
```

### mongodb3::mms\_automation_agent

Install the MMS Automation Agent.

Include `mongodb3::mms_automation_agent` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[mongodb3::mms_automation_agent]"
  ]
}
```

### mongodb3::mms\_monitoring_agent

Install the MMS Monitoring Agent.

Include `mongodb3::mms_monitoring_agent` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[mongodb3::mms_monitoring_agent]"
  ]
}
```

## Examples

### Default mongod.conf file contents

Simply `mongodb3::default` recipe with none of additional attribute setting

```json
{
  "run_list": [
    "recipe[mongodb3::default]"
  ]
}
```

#### Result of mongod.conf

```text
# THIS FILE IS MAINTAINED BY CHEF. DO NOT MODIFY AS IT WILL BE OVERWRITTEN.
---
systemLog:
  path: /var/log/mongodb/mongod.log
  logAppend: true
  destination: file
net:
  port: 27017
security:
  authorization: disabled
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  engine: mmapv1
```

### Replicaset

#### Role file

You can set the config attribute on node or wrapper recipe.

```json
{
  "name": "replica",
  "description": "Role for Replica set",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb3" : {
      "config" : {
        "mongod" : {
          "replication" : {
            "replSetName" : "replset-1"
          }
        }
      }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mongodb3::default]"
  ],
  "env_run_lists": {
  }
}
```

#### Result of mongod.conf

```text
# THIS FILE IS MAINTAINED BY CHEF. DO NOT MODIFY AS IT WILL BE OVERWRITTEN.
---
systemLog:
  path: /var/log/mongodb/mongod.log
  logAppend: true
  destination: file
net:
  port: 27017
security:
  authorization: disabled
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  engine: mmapv1
replication:
  replSetName: replset-1
```

### Config server

#### Role file

You can set the config attribute on node or wrapper recipe.

```json
{
  "name": "configsvr",
  "description": "Role for MongoDB Config server",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb3": {
      "config" : {
        "mongod" : {
          "net" : {
            "port" : 27019
          },
          "sharding" : {
            "clusterRole" : "configsvr"
          }
        }
      }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mongodb3::default]"
  ],
  "env_run_lists": {
  }
}
```

#### Result of mongod.conf

```text
# THIS FILE IS MAINTAINED BY CHEF. DO NOT MODIFY AS IT WILL BE OVERWRITTEN.
---
systemLog:
  path: /var/log/mongodb/mongod.log
  logAppend: true
  destination: file
net:
  port: 27019
security:
  authorization: disabled
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  engine: mmapv1
sharding:
  clusterRole: configsvr
```

### WiredTiger storage engine config

#### Role file

You can set the config attribute on node or wrapper recipe.

```json
{
  "name": "wired_tiger",
  "description": "Role for testing Wired Tiger storage engine",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb3" : {
      "config" : {
        "mongod" : {
          "storage" : {
            "dbPath" : "/var/lib/mongodb/wiredTiger",
            "engine" : "wiredTiger",
            "wiredTiger" : {
              "engineConfig" : {
                "cacheSizeGB" : 10,
                "statisticsLogDelaySecs" : 60,
                "journalCompressor" : "snappy",
                "directoryForIndexes" : false
              },
              "collectionConfig" : {
                "blockCompressor" : "snappy"
              },
              "indexConfig" : {
                "prefixCompression" : true
              }
            }
          }
        }
      }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mongodb3::default]"
  ],
  "env_run_lists": {
  }
}

```

#### Result of mongod.conf

```text
# THIS FILE IS MAINTAINED BY CHEF. DO NOT MODIFY AS IT WILL BE OVERWRITTEN.
---
systemLog:
  path: /var/log/mongodb/mongod.log
  logAppend: true
  destination: file
net:
  port: 27017
security:
  authorization: disabled
storage:
  dbPath: /var/lib/mongodb/wiredTiger
  journal:
    enabled: true
  engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 10
      statisticsLogDelaySecs: 60
      journalCompressor: snappy
      directoryForIndexes: false
    collectionConfig:
      blockCompressor: snappy
    indexConfig:
      prefixCompression: true
```

### Mongos

#### Role file

You can set the config attribute on node or wrapper recipe.

```json
{
  "name": "mongos",
  "description": "Role for Mongos",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb3" : {
      "config" : {
        "mongos" : {
          "sharding" : {
            "configDB" : "configsvr1:27019, configsvr2:27019, configsvr3:27019"
          }
        }
      }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mongodb3::mongos]"
  ],
  "env_run_lists": {
  }
}
```

#### Result of mongos.conf

```text
# THIS FILE IS MAINTAINED BY CHEF. DO NOT MODIFY AS IT WILL BE OVERWRITTEN.
---
net:
  port: 27017
  bindIp: 0.0.0.0
systemLog:
  path: /var/log/mongodb/mongos.log
  logAppend: true
  destination: file
sharding:
  autoSplit: true
  configDB: configsvr1:27019, configsvr2:27019, configsvr3:27019
  chunkSize: 64
```

### MMS Automation agent

#### Role file

You can set the config attribute on node or wrapper recipe.

```json
{
  "name": "mms_automation_agent",
  "description": "Role for MMS automation agent",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb3" : {
      "config" : {
        "mms" : {
          "mmsGroupId" : "grpgrpididid",
          "mmsApiKey" : "apikeykekekekeke"
        }
      }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mongodb3::mms_automation_agent]"
  ],
  "env_run_lists": {
  }
}

```

#### Result of `/etc/mongodb-mms/automation-agent.config`

```text
# /etc/mongodb-mms/automation-agent.config

#
# REQUIRED
# Enter your Group ID - It can be found at https://cloud.mongodb.com/settings/group
#
mmsGroupId=grpgrpididid

#
# REQUIRED
# Enter your API key - It can be found at https://cloud.mongodb.com/settings/group
#
mmsApiKey=apikeykekekekeke

#
# Base url of the MMS web server.
#
mmsBaseUrl=https://api-agents.mongodb.com

#
# Path to log file
#
logFile=/var/log/mongodb-mms-automation/automation-agent.log

#
# Path to backup cluster config to
#
mmsConfigBackup=/var/lib/mongodb-mms-automation/mms-cluster-config-backup.json

#
# Lowest log level to log.  Can be (in order): DEBUG, ROUTINE, INFO, WARN, ERROR, DOOM
#
logLevel=INFO

#
# Maximum number of rotated log files
#
maxLogFiles=10

#
# Maximum size in bytes of a log file (before rotating)
#
maxLogFileSize=268435456

#
# URL to proxy all HTTP requests through
#
#httpProxy=

#
# The absolute path to an non-system-standard location for the Kerberos configuration file
#
#krb5ConfigLocation=

#
# The path on disk that contains the trusted certificate authority certificates in PEM format.
#
#sslTrustedMMSServerCertificate=

#
# Use this option to disable certificate verification by setting this value to false.
#
#sslRequireValidMMSServerCertificates=

# For additional optional settings, please see
# https://docs.cloud.mongodb.com/reference/automation-agent/


```

### MMS Monitoring agent

#### Role file

You can set the config attribute on node or wrapper recipe.

```json
{
  "name": "mms_monitoring_agent",
  "description": "Role for MMS monitoring agent",
  "json_class": "Chef::Role",
  "default_attributes": {
    "mongodb3" : {
      "config" : {
        "mms" : {
          "api_key" : "apikeykekekekeke"
        }
      }
    }
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "recipe[mongodb3::mms_monitoring_agent]"
  ],
  "env_run_lists": {
  }
}

```

#### Result of `/etc/mongodb-mms/monitoring-agent.config`

```text
# THIS FILE IS MAINTAINED BY CHEF. DO NOT MODIFY AS IT WILL BE OVERWRITTEN.

#
# Enter your API key  - See: cloud.mongodb.com/settings/group
#
mmsApiKey=apikeykekekekeke

#
# Hostname of the MMS monitoring web server.
#
mmsBaseUrl=https://api-agents.mongodb.com

#
# URL to proxy all HTTP requests through
#
#httpProxy=

#
# Set to true to enable SSL support globally and to use SSL for all MongoDB connections.
#
#useSslForAllConnections=

#
# The path to the private key, client certificate, and optional intermediate certificates in PEM format
#
#sslClientCertificate=

#
# The password needed to decrypt the private key in the file specified in sslClientCertificate.
#
#sslClientCertificatePassword=

#
# The path on disk that contains the trusted certificate authority certificates in PEM format.
#
#sslTrustedServerCertificates=

#
# Use this option to disable certificate verification by setting this value to false.
#
#sslRequireValidServerCertificates=

#
# The Kerberos principal used by the agent.
#
#krb5Principal=

#
# The absolute path to Kerberos principal’s keytab file.
#
#krb5Keytab=

#
# The absolute path to an non-system-standard location for the Kerberos configuration file.
#
#krb5ConfigLocation=

#
# The default service name used by MongoDB is mongodb can specify a custom service name with the gssapiServiceName option.
#
#gsappiServiceName=

#
# By default the Monitoring Agent will use the trusted root CAs installed on the system. If the agent cannot find the trusted root CAs, configure these settings manually.
#
#sslTrustedMMSServerCertificate=

#
# You can disable certificate verification by setting this value to false.
#
#sslRequireValidMMSServerCertificates=

#
# Set to false if you do not with the Monitoring Agent to collect hardware statistics via Munin-node.
#
#enableMunin=


# For additional optional settings, please see
# https://docs.cloud.mongodb.com/reference/monitoring-agent/

```

## License and Authors

Author:: Sunggun Yu (sunggun.dev@gmail.com)

```text
Copyright (c) 2016, Sunggun Yu.

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
