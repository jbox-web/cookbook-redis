# Install rsync to do backups
package 'rsync'

# Install /usr/sbin/autoredisbackup
cookbook_file '/usr/sbin/autoredisbackup' do
  source 'sbin/autoredisbackup'
  mode   '0755'
end

# Install /etc/cron.daily/autoredisbackup
cookbook_file '/etc/cron.daily/autoredisbackup' do
  source 'cron/autoredisbackup'
  mode   '0755'
end

# Create Redis backup dir
directory node[:autoredisbackup][:config][:backupdir] do
  recursive true
  mode   '0700'
end

# Configure AutoRedisBackup
template '/etc/default/autoredisbackup' do
  dbdir      = node[:redis][:config][:dir]
  dbfilename = node[:redis][:config][:dbfilename]

  source    'autoredisbackup'
  variables config: node[:autoredisbackup][:config].merge(dbdir: dbdir, dbfilename: dbfilename)
end
