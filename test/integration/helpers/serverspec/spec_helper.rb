require 'serverspec'

set :backend, :exec

# Set path for testing
set :path, '/sbin:/usr/sbin:/usr/local/sbin:$PATH'
