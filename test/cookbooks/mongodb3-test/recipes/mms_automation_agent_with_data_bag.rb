#
# Cookbook Name:: mongodb3-test
# Recipe:: mms_automation_agent_with_data_bag
#
# Copyright 2016, Sunggun Yu
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

#
# The data bag content that is encrypted
#
# {
#   "id" : "mms-agent",
#   "environments": {
#     "dev": {
#       "mms_group_id" : "mms_group_id_from_data_bag",
#       "mms_api_key" : "mms_api_key_from_data_bag"
#     }
#   }
# }

# mms agent data bag
mms_data_bag_item = Chef::EncryptedDataBagItem.load('mongodb', 'mms-agent')
mms_data_bag = mms_data_bag_item['environments'][node.chef_environment]

node.set['mongodb3']['config']['mms']['mmsGroupId'] = mms_data_bag['mms_group_id']
node.set['mongodb3']['config']['mms']['mmsApiKey'] = mms_data_bag['mms_api_key']

include_recipe 'mongodb3::mms_automation_agent'
