DISTROS = {
  '9'  => 'stretch',
  '10' => 'buster',
}

# Get distribution name
distro = DISTROS[node[:platform_version]]

# Install Debian Backports repository
apt_repository "debian-backports-binary" do
  uri          'http://ftp.fr.debian.org/debian'
  components   ['main', 'contrib', 'non-free']
  distribution "#{distro}-backports"
end

# Install Redis
package 'redis-server' do
  default_release "#{distro}-backports"
end

# Configure Redis
if node[:redis][:config][:dir] != '/var/lib/redis'
  directory '/etc/systemd/system/redis-server.service.d'

  template '/etc/systemd/system/redis-server.service.d/data_dir.conf' do
    source    'systemd.conf.erb'
    variables dir: node[:redis][:config][:dir]
  end

  execute 'systemctl daemon-reload' do
    command 'systemctl daemon-reload'
  end
end

directory node[:redis][:config][:dir] do
  recursive true
  mode  '0750'
  owner 'redis'
  group 'redis'
end

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
