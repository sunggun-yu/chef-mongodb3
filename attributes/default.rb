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
default['mongodb3']['version'] = '3.2.0'

# Setup default package version attribute to install
pkg_version = node['mongodb3']['version']
case node['platform_family']
  when 'rhel', 'fedora'
    pkg_version =  "#{node['mongodb3']['version']}-1.el#{node.platform_version.to_i}" # ~FC019
    if node['platform'] == 'amazon'
      pkg_version = "#{node['mongodb3']['version']}-1.amzn1" # ~FC019
    end
end
pkg_major_version = pkg_version.to_f # eg. 3.0, 3.2

# Setup default package repo url attribute for each platform family or platform
case node['platform']
  when 'redhat', 'oracle','centos', 'fedora'
    pkg_repo = "https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/#{pkg_major_version}/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
  when 'amazon'
    pkg_repo = "https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/#{pkg_major_version}/x86_64/"
  when 'ubuntu'
    pkg_repo = 'http://repo.mongodb.org/apt/ubuntu'
  when 'debian'
    pkg_repo = 'http://repo.mongodb.org/apt/debian'
end

# Setup apt variables
case node['platform']
  when 'ubuntu'
    apt_repo_keyserver = 'hkp://keyserver.ubuntu.com:80'
    apt_repo_component = ['multiverse']
  when 'debian'
    apt_repo_keyserver = 'keyserver.ubuntu.com'
    apt_repo_component = ['main']
end

# Default attribute for MongoDB installation
case node['platform_family']
  when 'rhel', 'fedora'
    mongo_user = 'mongod'
    mongo_group = 'mongod'
    mongo_dbpath = '/var/lib/mongo'
    mongo_pid_file = '/var/run/mongodb/mongodb.pid'
    config_processManagement_fork = true
  when 'debian'
    mongo_user = 'mongodb'
    mongo_group = 'mongodb'
    mongo_dbpath = '/var/lib/mongodb'
    mongo_pid_file = nil
    config_processManagement_fork = nil
end

# MongoDB package repo url
default['mongodb3']['package']['repo']['url'] = pkg_repo

# MongoDB repository name
default['mongodb3']['package']['repo']['apt']['name'] = pkg_major_version.to_s

# MongoDB apt keyserver and key
default['mongodb3']['package']['repo']['apt']['keyserver'] = apt_repo_keyserver
if pkg_major_version >= 3.2
  default['mongodb3']['package']['repo']['apt']['key'] = 'EA312927'
else
  default['mongodb3']['package']['repo']['apt']['key'] = '7F0CEB10'
end
default['mongodb3']['package']['repo']['apt']['components'] = apt_repo_component

# MongoDB package version to install
default['mongodb3']['package']['version'] = pkg_version

# MongoDB user:group
default['mongodb3']['user'] = mongo_user
default['mongodb3']['group'] = mongo_group

# Mongod config file
default['mongodb3']['mongod']['config_file'] = '/etc/mongod.conf'

# Mongos config file
default['mongodb3']['mongos']['config_file'] = '/etc/mongos.conf'

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
if pkg_major_version >= 3.2
  default['mongodb3']['config']['mongod']['storage']['engine'] = 'wiredTiger' # default since 3.2 : wiredTiger
else
  default['mongodb3']['config']['mongod']['storage']['engine'] = 'mmapv1' # default until 3.2 : mmapv1
end

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

# MMS automation agent config attribute
default['mongodb3']['config']['mms']['mmsGroupId'] = nil
default['mongodb3']['config']['mms']['mmsApiKey'] = nil
default['mongodb3']['config']['mms']['logLevel'] = 'INFO'
default['mongodb3']['config']['mms']['maxLogFiles'] = 10
default['mongodb3']['config']['mms']['maxLogFileSize'] = 268435456
default['mongodb3']['config']['mms']['httpProxy'] = nil
