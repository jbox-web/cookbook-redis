# encoding: utf-8

title 'Test AutoRedisBackup installation'

describe file('/usr/sbin/autoredisbackup') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode')  { should cmp '0755' }
end

describe file('/etc/cron.daily/autoredisbackup') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode')  { should cmp '0755' }
end

describe file('/etc/default/autoredisbackup') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode')  { should cmp '0644' }
  its('content') { should include 'BACKUP_DIR=/var/backups/redis'  }
  its('content') { should include 'MAILCONTENT=quiet'  }
end

describe directory('/var/backups/redis') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode')  { should cmp '0700' }
end
