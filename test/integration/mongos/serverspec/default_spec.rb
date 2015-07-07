require 'spec_helper'

# RHEL and Debian family has different value for some of mongodb settings.
if os[:family] == 'redhat'
  mongo_user = 'mongod'
elsif ['debian', 'ubuntu']
  mongo_user = 'mongodb'
end

# Test `mongodb-org` package is installed.
describe package('mongodb-org-mongos') do
  it { should be_installed }
end

# Testing `mongos` service is not valid since test unit doesn't have valid config server
# Testing mongodb port listening is not valid since test unit doesn't have valid config server

# Test mongod process starts with expected mongodb config file
describe command('ps -ef | grep mongos') do
  its(:stdout) { should contain('/etc/mongos.conf') }
end

# Test mongodb config file is created with right permission.
describe file('/etc/mongos.conf') do
  it { should be_file }
  it { should be_owned_by mongo_user }
end

# Test mongodb replicaset key file is created with right permission.
describe file('/etc/mongodb.key') do
  it { should_not be_file }
end

# Test mongodb log file is created with right permission.
describe file('/var/log/mongodb/mongos.log') do
  it { should be_file }
  it { should be_owned_by mongo_user }
end
