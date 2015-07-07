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

# Add the MongoDB 3.0 Package repository
case node['platform_family']
  when 'rhel', 'fedora'
    yum_repository 'mongodb-org-3.0' do
      description 'MongoDB Repository'
      baseurl "https://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/#{node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'}"
      action :create
      gpgcheck false
      enabled true
    end
  when 'debian'
    apt_repository 'mongodb' do
      uri 'http://repo.mongodb.org/apt/ubuntu'
      distribution "#{node['lsb']['codename']}/mongodb-org/stable"
      components ['multiverse']
      keyserver 'hkp://keyserver.ubuntu.com:80'
      key '7F0CEB10'
      action :add
    end
    include_recipe 'apt'
end

# Select the packages to install by type
if node['mongodb3']['install']['mongod'] || node['mongodb3']['install']['configsvr']
  install_package = %w(mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools)
end

if node['mongodb3']['install']['mongos']
  install_package = %w(mongodb-org-shell mongodb-org-mongos mongodb-org-tools)
end

# Install MongoDB package
install_package.each do |pkg|
  package pkg do
    version node['mongodb3']['version']
    action :install
  end
end

# Create the db path if not exist.
directory node['mongodb3']['config']['db_path'] do
  owner node['mongodb3']['user']
  group node['mongodb3']['group']
  mode '0755'
  action :create
  recursive true
end

# Configure the MongoDB configuration file
if node['mongodb3']['install']['mongod'] || node['mongodb3']['install']['configsvr']

  unless node['mongodb3']['config']['key_file_content'].to_s.empty?
    # Create the key file if it is not exist
    key_file = node['mongodb3']['config']['key_file']
    file key_file do
      content node['mongodb3']['config']['key_file_content']
      mode '0600'
      owner node['mongodb3']['user']
      group node['mongodb3']['group']
    end
  end

  # Select the port number
  if node['mongodb3']['install']['configsvr']
    mongo_port = node['mongodb3']['config']['configsvr']['port']
  else
    mongo_port = node['mongodb3']['config']['port']
  end

  # Update the mongodb config file
  template node['mongodb3']['dbconfig_file'] do
    source 'mongodb.conf.erb'
    mode 0644
    variables(
        :port => mongo_port,
        :bind_ip => node['mongodb3']['config']['bind_ip'],
        :replset_name => node['mongodb3']['config']['replset_name'],
        :auth => node['mongodb3']['config']['auth'],
        :key_file => node['mongodb3']['config']['key_file'],
        :db_path => node['mongodb3']['config']['db_path'],
        :log_path => node['mongodb3']['config']['log_path']
    )
  end

  # Start the mongod service
  service 'mongod' do
    supports :start => true, :stop => true, :restart => true, :status => true
    action :enable
    subscribes :restart, "template[#{node['mongodb3']['dbconfig_file']}]", :delayed
    subscribes :restart, "template[#{node['mongodb3']['config']['key_file']}", :delayed
  end
end

# Mongos configuration
if node['mongodb3']['install']['mongos']

  # Create the mongodb user if not exist
  user node['mongodb3']['user'] do
    action :create
  end

  # Create the Mongos config file
  template node['mongodb3']['mongos']['config_file'] do
    source 'mongos.conf.erb'
    owner node['mongodb3']['user']
    mode 0644
    variables(
        :mongos_bind_ip => node['mongodb3']['config']['mongos']['bind_ip'],
        :mongos_port => node['mongodb3']['config']['mongos']['port'],
        :localPingThresholdMs => node['mongodb3']['config']['mongos']['localPingThresholdMs'],
        :autoSplit => node['mongodb3']['config']['mongos']['autoSplit'],
        :configDB => node['mongodb3']['config']['mongos']['configsvr'],
        :chunkSize => node['mongodb3']['config']['mongos']['chunkSize'],
        :log_path => node['mongodb3']['config']['mongos']['log_path']
    )
  end

  # Create the log directory
  directory File.dirname(node['mongodb3']['config']['mongos']['log_path']).to_s do
    owner node['mongodb3']['user']
    action :create
    recursive true
  end

  # Install runit service package
  # packagecloud cookbook is not working for oracle linux.
  if node['platform'] == 'oracle'
    # Install pygpgme package for imeyer runit yum repository
    package 'pygpgme' do
      ignore_failure true
    end
    # Install imeyer runit packagecloud yum repository
    yum_repository 'imeyer_runit' do
      description 'imeyer_runit'
      baseurl 'https://packagecloud.io/imeyer/runit/el/6/$basearch'
      gpgkey 'https://packagecloud.io/gpg.key'
      sslcacert '/etc/pki/tls/certs/ca-bundle.crt'
      sslverify false
      gpgcheck false
      action :create
    end
    # Set `['runit']['prefer_local_yum'] = true` to avoid install yum repository through packagecloud cookbook
    node.set['runit']['prefer_local_yum'] = true
  end

  # Install runit service package through runit::default recipe
  include_recipe 'runit::default'

  # Adding `mongos` service with runit
  runit_service 'mongos' do
    retries 3
    restart_on_update true
    options ({
                :user => node['mongodb3']['user'],
                :config_file => node['mongodb3']['mongos']['config_file']
            })
  end
end
