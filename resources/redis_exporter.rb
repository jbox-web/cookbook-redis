resource_name :redis_exporter
provides :redis_exporter

property :check_keys,             String
property :check_single_keys,      String
property :config_command,         String
property :connection_timeout,     String
property :debug,                  [true,  false],  default: false
property :include_system_metrics, [true,  false],  default: false
property :is_tile38,              [true,  false],  default: false
property :log_format,             String, default: 'txt'
property :namespace,              String, default: 'redis'
property :redis_addr,             String, default: 'redis://localhost:6379'
property :redis_alias,            String
property :redis_file,             String
property :redis_only_metrics,     [true,  false],  default: false
property :redis_password,         String
property :redis_password_file,    String
property :script,                 String
property :skip_tls_verification,  [true,  false],  default: false
property :user,                   String, default: 'redis_exporter'
property :web_listen_address,     String, default: '0.0.0.0:9121'
property :web_telemetry_path,     String

action :install do
  # Set property that can be queried with Chef search
  node.default['prometheus_exporters']['redis']['enabled'] = true

  options = "-web.listen-address '#{new_resource.web_listen_address}'"
  options += " -web.telemetry-path '#{new_resource.web_telemetry_path}'" if new_resource.web_telemetry_path
  options += " -log-format '#{new_resource.log_format}'"
  options += " -namespace '#{new_resource.namespace}'"
  options += " -check-keys '#{new_resource.check_keys}'" if new_resource.check_keys
  options += " -check-single-keys '#{new_resource.check_single_keys}'" if new_resource.check_single_keys
  options += " -config-command '#{new_resource.config_command}'" if new_resource.config_command
  options += " -connection-timeout '#{new_resource.connection_timeout}'" if new_resource.connection_timeout
  options += ' -debug' if new_resource.debug
  options += ' -include-system-metrics' if new_resource.include_system_metrics
  options += ' -is-tile38' if new_resource.is_tile38
  options += " -redis.addr '#{new_resource.redis_addr}'" if new_resource.redis_addr
  options += ' -redis-only-metrics' if new_resource.redis_only_metrics
  options += " -redis.password '#{new_resource.redis_password}'" if new_resource.redis_password
  options += " -script '#{new_resource.script}'" if new_resource.script
  options += ' -skip-tls-verification' if new_resource.skip_tls_verification

  service_name = "prometheus-redis-exporter-#{new_resource.name}"

  # Create exporter user
  directory '/var/lib/prometheus'
  user 'redis_exporter' do
    home        '/var/lib/prometheus/redis_exporter'
    shell       '/usr/sbin/nologin'
    manage_home true
  end

  # Create exporters parent dir
  directory '/opt/prometheus'

  # Download binary
  remote_file 'redis_exporter' do
    path "#{Chef::Config[:file_cache_path]}/redis_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source node['prometheus_exporters']['redis']['url']
    checksum node['prometheus_exporters']['redis']['checksum']
    notifies :restart, "service[#{service_name}]"
  end

  bash 'untar_redis_exporter' do
    code "tar -xzf #{Chef::Config[:file_cache_path]}/redis_exporter.tar.gz -C /opt/prometheus"
    action :nothing
    subscribes :run, 'remote_file[redis_exporter]', :immediately
  end

  bash 'move_redis_exporter' do
    code "mv /opt/prometheus/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64 /opt/prometheus/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}"
    action :nothing
    subscribes :run, 'bash[untar_redis_exporter]', :immediately
    only_if { Dir.exist?("/opt/prometheus/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64") && !Dir.exist?("/opt/prometheus/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}") }
  end

  link '/usr/local/bin/redis_exporter' do
    to "/opt/prometheus/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}/redis_exporter"
  end

  service service_name do
    action :nothing
  end

  systemd_unit "#{service_name}.service" do
    content(
      'Unit' => {
        'Description' => 'Systemd unit for Prometheus Redis Exporter',
        'After'       => 'network-online.target',
      },
      'Service' => {
        'Type'             => 'simple',
        'User'             => new_resource.user,
        'Group'            => new_resource.user,
        'ExecStart'        => "/usr/local/bin/redis_exporter #{options}",
        'WorkingDirectory' => '/var/lib/prometheus/redis_exporter',
        'Restart'          => 'on-failure',
        'RestartSec'       => '30s',
        'PIDFile'          => '/run/redis_exporter.pid',
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
      },
    )
    notifies :restart, "service[#{service_name}]"
    action :create
  end
end

action :enable do
  action_install
  service "prometheus-redis-exporter-#{new_resource.name}" do
    action :enable
  end
end

action :start do
  service "prometheus-redis-exporter-#{new_resource.name}" do
    action :start
  end
end

action :disable do
  service "prometheus-redis-exporter-#{new_resource.name}" do
    action :disable
  end
end

action :stop do
  service "prometheus-redis-exporter-#{new_resource.name}" do
    action :stop
  end
end
