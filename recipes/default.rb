# Install Debian Backports repository
apt_repository 'stretch-backports-binary' do
  uri          'http://ftp.fr.debian.org/debian'
  components   ['main', 'contrib', 'non-free']
  distribution 'stretch-backports'
end

# Install Redis
package 'redis-server' do
  default_release 'stretch-backports'
end

# Configure Redis
template '/etc/redis/redis.conf' do
  source    'redis.conf.erb'
  variables config: node[:redis][:config]
end

# Configure logrotate
cookbook_file '/etc/logrotate.d/redis-server' do
  source 'logrotate/redis-server'
end

# Create Redis log archive dir
directory '/var/log/OLD_LOGS/redis' do
  recursive true
end

# Restart Redis when config is changed
service 'redis' do
  subscribes :restart, 'template[/etc/redis/redis.conf]', :immediately
end
