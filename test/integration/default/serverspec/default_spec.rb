require 'spec_helper'

# RHEL and Debian family has different value for some of mongodb settings.
if os[:family] == 'redhat'
  mongo_user = 'mongod'
  mongo_data_dir = '/var/lib/mongo'
elsif ['debian', 'ubuntu']
  mongo_user = 'mongodb'
  mongo_data_dir = '/var/lib/mongodb'
end

# Test `mongodb-org-server` package is installed.
describe package('mongodb-org-server') do
  it { should be_installed }
end

# Test `mongod` service is running.
describe service('mongod') do
  it { should be_enabled }
  it { should be_running }
end

# Test mongodb port `27017` is listening.
describe port(27017) do
  it { should be_listening }
end

# Test mongod process starts with expected mongodb config file
describe command('ps -ef | grep mongod') do
  its(:stdout) { should contain('/etc/mongod.conf') }
end

# Test mongodb config file is created with right permission.
describe file('/etc/mongod.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

# Test mongodb data directory is created with right permission.
describe file(mongo_data_dir) do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by mongo_user }
  it { should be_grouped_into mongo_user }
end

# Test disable-transparent-hugepages script is created
describe file('/etc/init.d/disable-transparent-hugepages') do
  it { should be_file }
  it { should be_mode 755}
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

# Test disable-transparent-hugepages service is enabled.
describe service('disable-transparent-hugepages') do
  it { should be_enabled }
end

# Test transparent_hugepage is set to never
describe command('cat /sys/kernel/mm/transparent_hugepage/defrag') do
  its(:stdout) { should contain ('\[never\]') }
end

# Test transparent_hugepage is set to never
describe command('cat /sys/kernel/mm/transparent_hugepage/enabled') do
  its(:stdout) { should contain ('\[never\]') }
end

# Test mongodb log file is created with right permission.
describe file('/var/log/mongodb/mongod.log') do
  it { should be_file }
  it { should be_owned_by mongo_user }
end

# Test mongod process starts with expected mongodb config file
describe command('export LC_ALL="en_US.UTF-8"; mongo --eval "db.version()"') do
  its(:stdout) { should contain('3.2.8') }
end
