#
# Cookbook Name:: mongodb3-test
# Recipe:: default-30x
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

node.set['mongodb3']['version'] = '3.0.11'

# For package upgrade testing : executing converge twice with different version
# node.set['mongodb3']['version'] = '3.2.4'
# node.set['mongodb3']['package']['version'] = '3.2.4'
# node.set['mongodb3']['package']['repo']['apt']['name'] = '3.2'

include_recipe 'mongodb3::default'
