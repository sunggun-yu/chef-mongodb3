#
# Cookbook Name:: mongodb3
# Recipe:: default
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

include_recipe 'mongodb3::package_repo'

# Install MongoDB package
install_package = %w(mongodb-org-server mongodb-org-shell mongodb-org-tools)

install_package.each do |pkg|
  package pkg do
    version node['mongodb3']['package']['version']
    action :install
  end
end

# Create the db path if not exist.
directory node['mongodb3']['config']['mongod']['storage']['dbPath'] do
  owner node['mongodb3']['user']
  group node['mongodb3']['group']
  mode '0755'
  action :create
  recursive true
end

unless node['mongodb3']['config']['key_file_content'].to_s.empty?
  # Create the key file if it is not exist
  key_file = node['mongodb3']['config']['mongod']['security']['keyFile']
  file key_file do
    content node['mongodb3']['config']['key_file_content']
    mode '0600'
    owner node['mongodb3']['user']
    group node['mongodb3']['group']
  end
end

# Update the mongodb config file
template node['mongodb3']['mongod']['config_file'] do
  source 'mongodb.conf.erb'
  mode 0644
  variables(
      :config => node['mongodb3']['config']['mongod']
  )
  helpers Mongodb3Helper
end

# Start the mongod service
service 'mongod' do
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
  subscribes :restart, "template[#{node['mongodb3']['mongod']['config_file']}]", :delayed
  subscribes :restart, "template[#{node['mongodb3']['config']['mongod']['security']['keyFile']}", :delayed
end
