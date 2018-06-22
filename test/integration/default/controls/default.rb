# encoding: utf-8

title 'Test Redis installation'

describe package('redis-server') do
  it { should be_installed }
end

describe file('/etc/redis/redis.conf') do
  it { should exist }
end

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
