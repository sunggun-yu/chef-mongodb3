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

# Test mongodb log file is created with right permission.
describe file('/var/log/mongodb/mongod.log') do
  it { should be_file }
  it { should be_owned_by mongo_user }
end

# Test mongodb config file contains expected replica set name
describe file('/etc/mongod.conf') do
  it { should contain 'replSetName: replset-1' }
end

# Test mongodb replicaset key file is created with right permission.
describe file('/srv/mongodb/mongodb-keyfile') do
  it { should be_file }
  it { should be_mode 600 }
  it { should be_owned_by mongo_user }
  it { should be_grouped_into mongo_user }
end

# Test mongodb replicaset key file is matching
describe file('/srv/mongodb/mongodb-keyfile') do
  it { should contain "Mb5KNEpIVq1PRIZaA4lcV2KCi1BdSGuzhFUCH61tbhmgHk3Shcc8dbvYW1Lv7jC6\nAtrBWKG4Mn8G5fCTW0cEV0RexNhBRCmSUNszduVi00bMYipyisCD3UUu2ukdUqs9\nNRWlEqeAUEJp8nBZ0AnKpFdtYMsL3zKW7KepW9xWccC0DWQnfSmrZ19ppV0DNVRr\nS5zBbLw0pd7OImkovWAQurLdEVYlgXgkL2Sp7aOWIymrKmWe7leZ4+TITR6xXQ3H\nEcLuICxq+nyDOZ/eKblC5GTfcHyMfGRWiqdfuQeTJbWuo9xPCsbVgfz3c4saHphW\nMflwM1wKTFL/h2+dNSQfSDaOD9HZSprjqx0b4bFS5TsHfiJlaEfbZ0Mv9YPWd9Wi\nNnUDz6l6WW9UVIPCsTrCxRphzYjrn1MF2vIINypDbthpR4s97b89UtCxFsk/Rdzi\nN0RCQtf6a4UeeAf6SFZrWS2/PBzSCaaP/ic3fOaF7VAGQOand9fURkijWxiuBORB\nSP4ftXUoqROgjl1h4vz4C5BDERcN/TQtBmVcuhpqlwPFPhWBoCX09jUZRlodb181\nE9fDsISAZxsrmYNsqHtWwe/PioQFcRe55hk8FPC1TB+aHxtThof493Dd1nDzVXbp\nSOfttBB6qnG/XmgPXVNOov1kkmpaHjn8rvGN+SeMfq7XLnkJD24DgmW3037IYv2k\n/T2hNZaBBd875R+pVyzAmBR50yoJgiJjU/natq7VCcqJ4pMl/YjDvB1EFDQ/4sYy\nOnKtRrKmSEzsqarrKY6u1ttmmlF5i9q5vJmDUNVryxJOCZOS4V+Ma4ZPG3kkZ1sb\nPRS6ZUEBCdZW2Bscuxj3TJZDUuMS/dDq7FiGOC/hRm54YLgpwKaNK3Pc0Uw3FI3e\nObDVLKllDS6cKPDSetf3IJ3CBrCwpUtxDtLA5hIESzpBqbs9Kdm2GPO7UmapJ/ZQ\nKLkCs351W7MCmgXPqv0E7qFXcVnQ" }
end
