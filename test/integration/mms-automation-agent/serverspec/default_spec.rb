require 'spec_helper'

# RHEL and Debian family has different value for some of mongodb settings.
if os[:family] == 'redhat'
  mongo_user = 'mongod'
elsif ['debian', 'ubuntu']
  mongo_user = 'mongodb'
end

# MMS Automation Agent is installed
describe package('mongodb-mms-automation-agent-manager') do
  it { should be_installed }
end

# MMS Automation Agent is running
describe service('mongodb-mms-automation-agent') do
  it { should be_enabled }
  it { should be_running }
end

# MMS Automation Agent config file is in place
describe file('/etc/mongodb-mms/automation-agent.config') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by mongo_user }
end

# MMS Automation Agent config file is contains group_id and api_key value
describe file('/etc/mongodb-mms/automation-agent.config') do
  it { should contain 'mmsGroupId=grpgrpididid' }
  it { should contain 'mmsApiKey=apikeykekekekeke' }
end
