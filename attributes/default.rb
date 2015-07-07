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

default['mongodb3']['version'] = '3.0.4'

# Default attribute for MongoDB installation
case node['platform_family']
  when 'rhel', 'fedora'
    mongo_user = 'mongod'
    mongo_group = 'mongod'
    mongo_dbpath = '/var/lib/mongo'
    default['mongodb3']['version'] = "#{node['mongodb3']['version']}-1.el6"
  when 'debian'
    mongo_user = 'mongodb'
    mongo_group = 'mongodb'
    mongo_dbpath = '/var/lib/mongodb'
end

default['mongodb3']['user'] = mongo_user
default['mongodb3']['group'] = mongo_group

# mongod, mongos, configsvr
default['mongodb3']['install']['type'] = 'mongod'

default['mongodb3']['install']['mongod'] = true
default['mongodb3']['install']['configsvr'] = false
default['mongodb3']['install']['mongos'] = false

default['mongodb3']['install']['packages'] = ['mongodb-org', 'mongodb-org-server', 'mongodb-org-shell', 'mongodb-org-mongos', 'mongodb-org-tools']
default['mongodb3']['dbconfig_file'] = '/etc/mongod.conf'

# Mongod config
default['mongodb3']['config']['port'] = 27017
default['mongodb3']['config']['bind_ip'] = '0.0.0.0'
default['mongodb3']['config']['replset_name'] = nil
# Auth : enabled/disabled
default['mongodb3']['config']['auth'] = 'disabled'
default['mongodb3']['config']['key_file'] = '/etc/mongodb.key'
default['mongodb3']['config']['key_file_content'] = nil
default['mongodb3']['config']['db_path'] = mongo_dbpath
default['mongodb3']['config']['log_path'] = '/var/log/mongodb/mongod.log'

# MongoDB Storage Engine - mmapv1 | wiredTiger. Default is mmapv1
default['mongodb3']['config']['storage']['engine'] = 'mmapv1'

# WiredTiger Option
default['mongodb3']['config']['storage']['wiredTiger']['engineConfig']['cacheSizeGB'] = 10
default['mongodb3']['config']['storage']['wiredTiger']['engineConfig']['statisticsLogDelaySecs'] = 60
default['mongodb3']['config']['storage']['wiredTiger']['engineConfig']['journalCompressor'] = 'snappy'
default['mongodb3']['config']['storage']['wiredTiger']['engineConfig']['directoryForIndexes'] = false
default['mongodb3']['config']['storage']['wiredTiger']['collectionConfig']['blockCompressor'] = 'snappy'
default['mongodb3']['config']['storage']['wiredTiger']['indexConfig']['prefixCompression'] = true

# Config server port will be applied to port section if configsvr install is true.
default['mongodb3']['config']['configsvr']['port'] = 27019

# Mongos only config
# Config server : ex) 'abc:27019, def:27019'
default['mongodb3']['mongos']['config_file'] = '/etc/mongos.conf'
default['mongodb3']['config']['mongos']['bind_ip'] = '127.0.0.1'
default['mongodb3']['config']['mongos']['port'] = 27018
default['mongodb3']['config']['mongos']['configsvr'] = nil
# localPingThresholdMs : Default : 15
default['mongodb3']['config']['mongos']['localPingThresholdMs'] = 15
# autoSplit : Default : true
default['mongodb3']['config']['mongos']['autoSplit'] = true
# chunkSize : Default : 64
default['mongodb3']['config']['mongos']['chunkSize'] = 64
default['mongodb3']['config']['mongos']['log_path'] = '/var/log/mongodb/mongos.log'
