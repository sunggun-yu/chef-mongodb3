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

pkg_major_version = node['mongodb3']['version'].to_f # eg. 3.0, 3.2

# Setup default package version attribute to install
pkg_version = node['mongodb3']['version']
case node['platform_family']
  when 'rhel', 'fedora'
    pkg_version =  "#{node['mongodb3']['version']}-1.el#{node.platform_version.to_i}" # ~FC019
    if node['platform'] == 'amazon'
      pkg_version = "#{node['mongodb3']['version']}-1.amzn1" # ~FC019
    end
end

# Setup default package repo url attribute for each platform family or platform
case node['platform']
  when 'redhat', 'oracle','centos', 'fedora' # ~FC024
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

# MongoDB package version to install
if node['mongodb3']['package']['version'].nil?
  node.set['mongodb3']['package']['version'] = pkg_version
end

# MongoDB package repo url
if node['mongodb3']['package']['repo']['url'].nil?
  node.set['mongodb3']['package']['repo']['url'] = pkg_repo
end

# MongoDB repository name
if node['mongodb3']['package']['repo']['apt']['name'].nil?
  node.set['mongodb3']['package']['repo']['apt']['name'] = pkg_major_version.to_s
end

# MongoDB apt keyserver and key
if node['mongodb3']['package']['repo']['apt']['keyserver'].nil?
  node.set['mongodb3']['package']['repo']['apt']['keyserver'] = apt_repo_keyserver
end

if node['mongodb3']['package']['repo']['apt']['key'].nil?
  if pkg_major_version >= 3.2
    node.set['mongodb3']['package']['repo']['apt']['key'] = 'EA312927'
  else
    node.set['mongodb3']['package']['repo']['apt']['key'] = '7F0CEB10'
  end
end

if node['mongodb3']['package']['repo']['apt']['components'].nil?
  node.set['mongodb3']['package']['repo']['apt']['components'] = apt_repo_component
end

# Add the MongoDB Package repository
case node['platform_family']
  when 'rhel', 'fedora'
    yum_repository "mongodb-org-#{pkg_major_version}" do
      description 'MongoDB Repository'
      baseurl node['mongodb3']['package']['repo']['url']
      action :create
      gpgcheck false
      enabled true
      sslverify false
    end
  when 'debian'
    apt_repository "mongodb-org-#{pkg_major_version}" do
      uri node['mongodb3']['package']['repo']['url']
      if node['platform'] == 'ubuntu' and node['platform_version'].to_f == 15.04
        # seems that mongodb supports only LTS versions of Ubuntu
        distribution "trusty/mongodb-org/#{node['mongodb3']['package']['repo']['apt']['name']}"
      else
        distribution "#{node['lsb']['codename']}/mongodb-org/#{node['mongodb3']['package']['repo']['apt']['name']}"
      end
      components node['mongodb3']['package']['repo']['apt']['components']
      keyserver node['mongodb3']['package']['repo']['apt']['keyserver']
      key node['mongodb3']['package']['repo']['apt']['key']
      action :add
    end
    include_recipe 'apt'
end
