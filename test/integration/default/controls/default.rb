# encoding: utf-8

title 'Test Redis installation'

DISTROS = {
  '9'  => 'stretch',
  '10' => 'buster',
}

# Test Redis package
describe package('redis-server') do
  it { should be_installed }
end

distro = DISTROS[os[:release].to_s.split('.').first]

describe file("/etc/apt/sources.list.d/#{distro}-backports-binary.list") do
  it { should exist }
  its('content') { should include %Q(deb      http://ftp.fr.debian.org/debian #{distro}-backports main contrib non-free)  }
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
