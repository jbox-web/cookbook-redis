# Test Prometheus redis_exporter service
describe service('prometheus-redis-exporter-main') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(9121) do
  its('processes') { should include 'redis_exporter' }
  its('protocols') { should include 'tcp6' }
  its('addresses') { should include '::' }
end
