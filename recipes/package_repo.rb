#
# Cookbook Name:: mongodb3
# Recipe:: package_repo
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

# Add the MongoDB 3.0 Package repository
case node['platform_family']
  when 'rhel', 'fedora'
    yum_repository 'mongodb-org-3.0' do
      description 'MongoDB Repository'
      baseurl node['mongodb3']['package']['repo']['url']
      action :create
      gpgcheck false
      enabled true
      sslverify false
    end
  when 'debian'
    apt_repository 'mongodb' do
      uri node['mongodb3']['package']['repo']['url']
      distribution "#{node['lsb']['codename']}/mongodb-org/#{node['mongodb3']['package']['repo']['apt']['name']}"
      components node['mongodb3']['package']['repo']['apt']['components']
      keyserver node['mongodb3']['package']['repo']['apt']['keyserver']
      key node['mongodb3']['package']['repo']['apt']['key']
      action :add
    end
    include_recipe 'apt'
end
