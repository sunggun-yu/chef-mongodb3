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
    case node['platform_family']
      when 'debian'
        # bypass dpkg errors about pre-existing init or conf file
        options '-o Dpkg::Options::="--force-confold" --force-yes'
    end
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

# Create the systemLog directory.
directory File.dirname(node['mongodb3']['config']['mongod']['systemLog']['path']).to_s do
  owner node['mongodb3']['user']
  group node['mongodb3']['group']
  mode '0755'
  action :create
  recursive true
end

unless node['mongodb3']['config']['key_file_content'].to_s.empty?
  # Create the key file if it is not exist
  key_file = node['mongodb3']['config']['mongod']['security']['keyFile']

  # Create the directory for key file
  directory File.dirname(key_file).to_s do
    action :create
    owner node['mongodb3']['user']
    group node['mongodb3']['group']
    recursive true
  end

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

# Disable Transparent Huge Pages (THP)
# https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/
cookbook_file '/etc/init.d/disable-transparent-hugepages' do
  source 'disable-transparent-hugepages'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  only_if {
    node['mongodb3']['mongod']['disable-transparent-hugepages']
  }
end

case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 15.04
      cookbook_file '/lib/systemd/system/disable-transparent-hugepages.service' do
        source 'disable-transparent-hugepages.service'
        owner 'root'
        group 'root'
        mode '0655'
        action :create
        only_if {
          node['mongodb3']['mongod']['disable-transparent-hugepages']
        }
      end
    end
end

service 'disable-transparent-hugepages' do
  case node['platform']
    when 'ubuntu'
      if node['platform_version'].to_f >= 15.04
        provider Chef::Provider::Service::Systemd
      end
  end
  action [ :enable, :start ]
  only_if {
    node['mongodb3']['mongod']['disable-transparent-hugepages']
  }
end

# Create the mongod.service file
case node['platform']
  when 'ubuntu'
    template '/lib/systemd/system/mongod.service' do
      source 'mongod.service.erb'
      mode 0644
      only_if { node['platform_version'].to_f >= 15.04 }
    end
end

# Start the mongod service
service 'mongod' do
  case node['platform']
    when 'ubuntu'
      if node['platform_version'].to_f >= 15.04
        provider Chef::Provider::Service::Systemd
      elsif node['platform_version'].to_f >= 14.04
        provider Chef::Provider::Service::Upstart
      end
  end
  supports :start => true, :stop => true, :restart => true, :status => true
  action :enable
  subscribes :restart, "template[#{node['mongodb3']['mongod']['config_file']}]", :delayed
  subscribes :restart, "template[#{node['mongodb3']['config']['mongod']['security']['keyFile']}", :delayed
end
