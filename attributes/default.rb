#
# Cookbook Name:: mongodb3
# Attribute:: default
#
# Copyright 2015, Sunggun Yu
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# MongoDB version to install
default['mongodb3']['version'] = '3.2.8'

# Please note : The default values for ['mongodb3']['package'] attributes will be set in `package_repo` recipe.
# but, You can set custom values for yum/apt repo url, yum package version or apt related in your wrapper

# MongoDB package version to install : eg. 3.0.8, 3.2.1, 3.2.1-1.el6 or 3.2.1-1.amzn1
default['mongodb3']['package']['version'] = nil

# MongoDB package repo url
# eg. ubuntu : 'http://repo.mongodb.org/apt/ubuntu'
# eg. centos : 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/'
default['mongodb3']['package']['repo']['url'] = nil

# MongoDB repository info for apt
default['mongodb3']['package']['repo']['apt']['name'] = nil  # eg. 3.0, 3.2
default['mongodb3']['package']['repo']['apt']['keyserver'] = nil # eg. hkp://keyserver.ubuntu.com:80
default['mongodb3']['package']['repo']['apt']['key'] = nil # eg. 3.2 : 'EA312927', 3.0 : '7F0CEB10'
default['mongodb3']['package']['repo']['apt']['components'] = nil # eg. ['multiverse']

# Default attribute for MongoDB installation
case node['platform_family']
  when 'rhel', 'fedora'
    mongo_user = 'mongod'
    mongo_group = 'mongod'
    mongo_dbpath = '/var/lib/mongo'
    # To guarantee the compatibility for centos 6 in previous version of mongodb3 cookbook
    if node['platform_version'].to_i >= 7
      mongo_pid_file = '/var/run/mongodb/mongod.pid'
    else
      mongo_pid_file = '/var/run/mongodb/mongodb.pid'
    end
    config_processManagement_fork = true
  when 'debian'
    mongo_user = 'mongodb'
    mongo_group = 'mongodb'
    mongo_dbpath = '/var/lib/mongodb'
    mongo_pid_file = nil
    config_processManagement_fork = nil
end

# MongoDB user:group
default['mongodb3']['user'] = mongo_user
default['mongodb3']['group'] = mongo_group

# Mongod config file
default['mongodb3']['mongod']['config_file'] = '/etc/mongod.conf'

# Disable Transparent Huge Pages (THP)
default['mongodb3']['mongod']['disable-transparent-hugepages'] = false

# Mongos config file
default['mongodb3']['mongos']['config_file'] = '/etc/mongos.conf'

# Runit template cookbook for mongos
default['mongodb3']['mongos']['runit_template_cookbook'] = 'mongodb3'

# Key file contents
default['mongodb3']['config']['key_file_content'] = nil

# Key server
default['mongodb3']['keyserver'] = 'hkp://keyserver.ubuntu.com:80'

# Mongod config
# The default value of the attribute is referred to the MongoDB documentation.
# The attribute value of nil will be removed from mongod config file.
# This cookbook fills nil for some of the attribute value to concise initial mongod config file.
# Also, deprecated attributed is not applied.

# systemLog Options : http://docs.mongodb.org/manual/reference/configuration-options/#systemlog-options
default['mongodb3']['config']['mongod']['systemLog']['verbosity'] = nil # default : 0
default['mongodb3']['config']['mongod']['systemLog']['quiet'] = nil # default : false
default['mongodb3']['config']['mongod']['systemLog']['traceAllException'] = nil # default : false
default['mongodb3']['config']['mongod']['systemLog']['syslogFacility'] = nil # default : 'user'
default['mongodb3']['config']['mongod']['systemLog']['path'] = '/var/log/mongodb/mongod.log'
default['mongodb3']['config']['mongod']['systemLog']['logAppend'] = true # default : false
default['mongodb3']['config']['mongod']['systemLog']['logRotate'] = nil # default : 'rename'
default['mongodb3']['config']['mongod']['systemLog']['destination'] = 'file' # default : 'file'
default['mongodb3']['config']['mongod']['systemLog']['timeStampFormat'] = nil # default : 'iso8601-local'

# systemLog.component Options : http://docs.mongodb.org/manual/reference/configuration-options/#systemlog-component-options
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

# processManagement Options : http://docs.mongodb.org/manual/reference/configuration-options/#processmanagement-options

default['mongodb3']['config']['mongod']['processManagement']['fork'] = config_processManagement_fork # default : false
default['mongodb3']['config']['mongod']['processManagement']['pidFilePath'] = mongo_pid_file

# net Options : http://docs.mongodb.org/manual/reference/configuration-options/#net-options
default['mongodb3']['config']['mongod']['net']['port'] = 27017
default['mongodb3']['config']['mongod']['net']['bindIp'] = nil # default : '0.0.0.0'
default['mongodb3']['config']['mongod']['net']['maxIncomingConnections'] = nil # default : 65536
default['mongodb3']['config']['mongod']['net']['wireObjectCheck'] = nil # default : true
default['mongodb3']['config']['mongod']['net']['ipv6'] = nil # default : false

# net.unixDomainSocket Options : http://docs.mongodb.org/manual/reference/configuration-options/#net-unixdomainsocket-options
default['mongodb3']['config']['mongod']['net']['unixDomainSocket']['enabled'] = nil # default : true
default['mongodb3']['config']['mongod']['net']['unixDomainSocket']['pathPrefix'] = nil # default : '/tmp'
default['mongodb3']['config']['mongod']['net']['unixDomainSocket']['filePermissions'] = nil # default : '0700'

# net.http Options : http://docs.mongodb.org/manual/reference/configuration-options/#net-http-options
default['mongodb3']['config']['mongod']['net']['http']['enabled'] = nil # default : false
default['mongodb3']['config']['mongod']['net']['http']['JSONPEnabled'] = nil # default : false
default['mongodb3']['config']['mongod']['net']['http']['RESTInterfaceEnabled'] = nil # default : false

# net.ssl Options : http://docs.mongodb.org/manual/reference/configuration-options/#net-ssl-options
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

# security Options : http://docs.mongodb.org/manual/reference/configuration-options/#security-options
default['mongodb3']['config']['mongod']['security']['keyFile'] = nil
default['mongodb3']['config']['mongod']['security']['clusterAuthMode'] = nil
default['mongodb3']['config']['mongod']['security']['authorization'] = 'disabled'
default['mongodb3']['config']['mongod']['security']['javascriptEnabled'] = nil # default : true

# security.sasl Options : http://docs.mongodb.org/manual/reference/configuration-options/#security-sasl-options
default['mongodb3']['config']['mongod']['security']['sasl']['hostName'] = nil
default['mongodb3']['config']['mongod']['security']['sasl']['serviceName'] = nil
default['mongodb3']['config']['mongod']['security']['sasl']['saslauthdSocketPath'] = nil

# storage Options : http://docs.mongodb.org/manual/reference/configuration-options/#storage-options
default['mongodb3']['config']['mongod']['storage']['dbPath'] = mongo_dbpath
default['mongodb3']['config']['mongod']['storage']['indexBuildRetry'] = nil # default : true
default['mongodb3']['config']['mongod']['storage']['repairPath'] = nil
default['mongodb3']['config']['mongod']['storage']['journal']['enabled'] = true
default['mongodb3']['config']['mongod']['storage']['directoryPerDB'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['syncPeriodSecs'] = nil # default : 60
default['mongodb3']['config']['mongod']['storage']['engine'] = nil # default -  since 3.2 : wiredTiger, until 3.2 : mmapv1

# storage.mmapv1 Options : http://docs.mongodb.org/manual/reference/configuration-options/#storage-mmapv1-options
default['mongodb3']['config']['mongod']['storage']['mmapv1']['preallocDataFiles'] = nil # default : true
default['mongodb3']['config']['mongod']['storage']['mmapv1']['nsSize'] = nil # default : 16
default['mongodb3']['config']['mongod']['storage']['mmapv1']['quota']['enforced'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['mmapv1']['quota']['maxFilesPerDB'] = nil # default : 8
default['mongodb3']['config']['mongod']['storage']['mmapv1']['smallFiles'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['mmapv1']['journal']['debugFlags'] = nil
default['mongodb3']['config']['mongod']['storage']['mmapv1']['journal']['commitIntervalMs'] = nil # default : 100 or 30

# storage.wiredTiger Options : http://docs.mongodb.org/manual/reference/configuration-options/#storage-wiredtiger-options
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['cacheSizeGB'] = nil
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['statisticsLogDelaySecs'] = nil # default : 0
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['journalCompressor'] = nil # default : 'snappy'
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['engineConfig']['directoryForIndexes'] = nil # default : false
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['collectionConfig']['blockCompressor'] = nil # default : 'snappy'
default['mongodb3']['config']['mongod']['storage']['wiredTiger']['indexConfig']['prefixCompression'] = nil # default : true

# operationProfiling Options : http://docs.mongodb.org/manual/reference/configuration-options/#operationprofiling-options
default['mongodb3']['config']['mongod']['operationProfiling']['slowOpThresholdMs'] = nil # default : 100
default['mongodb3']['config']['mongod']['operationProfiling']['mode'] = nil # default : 'off'

# replication Options : http://docs.mongodb.org/manual/reference/configuration-options/#replication-options
default['mongodb3']['config']['mongod']['replication']['oplogSizeMB'] = nil
default['mongodb3']['config']['mongod']['replication']['replSetName'] = nil
default['mongodb3']['config']['mongod']['replication']['secondaryIndexPrefetch'] = nil # default : 'all'

# sharding Options : http://docs.mongodb.org/manual/reference/configuration-options/#sharding-options
default['mongodb3']['config']['mongod']['sharding']['clusterRole'] = nil
default['mongodb3']['config']['mongod']['sharding']['archiveMovedChunks'] = nil # default : true

# auditLog Options : http://docs.mongodb.org/manual/reference/configuration-options/#auditlog-options
default['mongodb3']['config']['mongod']['auditLog']['destination'] = nil
default['mongodb3']['config']['mongod']['auditLog']['format'] = nil
default['mongodb3']['config']['mongod']['auditLog']['path'] = nil
default['mongodb3']['config']['mongod']['auditLog']['filter'] = nil

# snmp Options : http://docs.mongodb.org/manual/reference/configuration-options/#snmp-options
default['mongodb3']['config']['mongod']['snmp']['subagent'] = nil
default['mongodb3']['config']['mongod']['snmp']['master'] = nil

# Mongos config
default['mongodb3']['config']['mongos']['net']['port'] = 27018 # default : 27017
default['mongodb3']['config']['mongos']['net']['bindIp'] = '127.0.0.1' # default : '0.0.0.0'
default['mongodb3']['config']['mongos']['systemLog']['path'] = '/var/log/mongodb/mongos.log'
default['mongodb3']['config']['mongos']['systemLog']['logAppend'] = true # default : false
default['mongodb3']['config']['mongos']['systemLog']['destination'] = 'file' # default : 'file'

# mongos-only Options : http://docs.mongodb.org/manual/reference/configuration-options/#mongos-only-options
default['mongodb3']['config']['mongos']['replication']['localPingThresholdMs'] = nil # default : 15
default['mongodb3']['config']['mongos']['sharding']['autoSplit'] = true # default : true
default['mongodb3']['config']['mongos']['sharding']['configDB'] = nil
default['mongodb3']['config']['mongos']['sharding']['chunkSize'] = 64 # default : 64

# MMS automation and monitoring agent config attributes
## common attributes for both automation and monitoring agent
default['mongodb3']['config']['mms']['mmsApiKey'] = nil
default['mongodb3']['config']['mms']['mmsBaseUrl'] = 'https://api-agents.mongodb.com'
default['mongodb3']['config']['mms']['httpProxy'] = nil
default['mongodb3']['config']['mms']['krb5ConfigLocation'] = nil
default['mongodb3']['config']['mms']['sslTrustedMMSServerCertificate'] = nil
default['mongodb3']['config']['mms']['sslRequireValidMMSServerCertificates'] = nil

## Attributes for automation agent
default['mongodb3']['config']['mms']['mmsGroupId'] = nil
default['mongodb3']['config']['mms']['logFile'] = '/var/log/mongodb-mms-automation/automation-agent.log'
default['mongodb3']['config']['mms']['mmsConfigBackup'] = '/var/lib/mongodb-mms-automation/mms-cluster-config-backup.json'
default['mongodb3']['config']['mms']['logLevel'] = 'INFO'
default['mongodb3']['config']['mms']['maxLogFiles'] = 10
default['mongodb3']['config']['mms']['maxLogFileSize'] = 268435456

## Attributes for monitoring agent
default['mongodb3']['config']['mms']['useSslForAllConnections'] = nil
default['mongodb3']['config']['mms']['sslClientCertificate'] = nil
default['mongodb3']['config']['mms']['sslClientCertificatePassword'] = nil
default['mongodb3']['config']['mms']['sslTrustedServerCertificates'] = nil
default['mongodb3']['config']['mms']['sslRequireValidServerCertificates'] = nil
default['mongodb3']['config']['mms']['krb5Principal'] = nil
default['mongodb3']['config']['mms']['krb5Keytab'] = nil
default['mongodb3']['config']['mms']['gsappiServiceName'] = nil
default['mongodb3']['config']['mms']['enableMunin'] = nil
