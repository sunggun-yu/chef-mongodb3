require 'spec_helper'

# MMS Automation Agent is installed
describe package('mongodb-mms-monitoring-agent') do
  it { should be_installed }
end

# MMS Automation Agent is running
describe service('mongodb-mms-monitoring-agent') do
  it { should be_enabled }
  it { should be_running }
end

# MMS Automation Agent config file is in place
describe file('/etc/mongodb-mms/monitoring-agent.config') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by 'mongodb-mms-agent' }
end

# MMS Automation Agent config file is contains group_id and api_key value
describe file('/etc/mongodb-mms/monitoring-agent.config') do
  it { should contain 'mmsApiKey=apikeykekekekeke' }
end
