#
# Cookbook Name:: mongodb3
# Recipe:: mms_automation_agent
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

# Install curl
package 'curl' do
  action :install
end

# Set variables by platform
case node['platform_family']
  when 'rhel', 'fedora'
    mms_agent_source = 'https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager-latest.x86_64.rpm'
    mms_agent_file = '/root/mongodb-mms-automation-agent-manager-latest.x86_64.rpm'
  when 'debian'
    if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 15.04
      mms_agent_source = 'https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb'
      mms_agent_file = '/root/mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb'
    else
      mms_agent_source = 'https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.deb'
      mms_agent_file = '/root/mongodb-mms-automation-agent-manager_latest_amd64.deb'
    end
end

# Download the mms automation agent manager latest
remote_file mms_agent_file do
  source mms_agent_source
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# Install package
case node['platform_family']
  when 'rhel', 'fedora'
    rpm_package 'mongodb-mms-automation-agent-manager' do
      source mms_agent_file
      action :install
    end
  when 'debian'
    dpkg_package 'mongodb-mms-automation-agent-manager' do
      source mms_agent_file
      action :install
    end
end

# Create or modify the mms agent config file
template '/etc/mongodb-mms/automation-agent.config' do
  source 'automation-agent.config.erb'
  mode 0600
  owner node['mongodb3']['user']
  group node['mongodb3']['group']
  variables(
      :config => node['mongodb3']['config']['mms']
  )
end

# Change ownership of data directory to mongo user
directory node['mongodb3']['config']['mongod']['storage']['dbPath'] do
  owner node['mongodb3']['user']
  group node['mongodb3']['group']
  recursive true
  action :create
end

# Start the mms automation agent
service 'mongodb-mms-automation-agent' do
  # The service provider of MMS Agent for Ubuntu is upstart
  provider Chef::Provider::Service::Upstart if node['platform_family'] == 'debian'
  provider Chef::Provider::Service::Systemd if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 15.04
  supports :status => true, :restart => true, :stop => true
  action [ :enable, :start ]
end
