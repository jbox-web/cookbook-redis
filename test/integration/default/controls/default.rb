# encoding: utf-8

title 'Test Redis installation'

# Fetch Inspec inputs
debian_release = input('debian_release')
redis_version  = input('redis_version')

# Test Redis package
describe package('redis-server') do
  it { should be_installed }
  its('version') { should eq redis_version }
end

if debian_release == "buster"
  describe file("/etc/apt/sources.list.d/debian-backports-binary.list") do
    it { should exist }
    its('content') { should include %Q(deb      http://ftp.debian.org/debian #{debian_release}-backports main contrib non-free)  }
  end
end

# Test Redis config
describe file('/etc/redis/redis.conf') do
  it { should exist }
end

# Test Redis service
describe service('redis-server') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(6379) do
  its('processes') { should include 'redis-server' }
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '127.0.0.1' }
end
