# Default Redis config
default['redis']['config']['daemonize']                            = 'yes'
default['redis']['config']['pidfile']                              = '/var/run/redis/redis-server.pid'
default['redis']['config']['port']                                 = 6379
default['redis']['config']['bind']                                 = '127.0.0.1'
default['redis']['config']['tcp-backlog']                          = 511
default['redis']['config']['tcp-keepalive']                        = 300
default['redis']['config']['loglevel']                             = 'notice'
default['redis']['config']['logfile']                              = '/var/log/redis/redis-server.log'
default['redis']['config']['databases']                            = 16
default['redis']['config']['save']['900']                          = 1
default['redis']['config']['save']['300']                          = 10
default['redis']['config']['save']['60']                           = 10000
default['redis']['config']['stop-writes-on-bgsave-error']          = 'yes'
default['redis']['config']['rdbcompression']                       = 'yes'
default['redis']['config']['rdbchecksum']                          = 'yes'
default['redis']['config']['dbfilename']                           = 'dump.rdb'
default['redis']['config']['dir']                                  = '/var/lib/redis'
default['redis']['config']['slave-serve-stale-data']               = 'yes'
default['redis']['config']['slave-read-only']                      = 'yes'
default['redis']['config']['repl-disable-tcp-nodelay']             = 'no'
default['redis']['config']['slave-priority']                       = 100
default['redis']['config']['appendonly']                           = 'no'
default['redis']['config']['appendfilename']                       = 'appendonly.aof'
default['redis']['config']['appendfsync']                          = 'everysec'
default['redis']['config']['no-appendfsync-on-rewrite']            = 'no'
default['redis']['config']['auto-aof-rewrite-percentage']          = 100
default['redis']['config']['auto-aof-rewrite-min-size']            = '64mb'
default['redis']['config']['lua-time-limit']                       = 5000
default['redis']['config']['slowlog-log-slower-than']              = 10000
default['redis']['config']['slowlog-max-len']                      = 128
default['redis']['config']['notify-keyspace-events']               = '""'
default['redis']['config']['hash-max-ziplist-entries']             = 512
default['redis']['config']['hash-max-ziplist-value']               = 64
default['redis']['config']['list-max-ziplist-entries']             = 512
default['redis']['config']['list-max-ziplist-value']               = 64
default['redis']['config']['set-max-intset-entries']               = 512
default['redis']['config']['zset-max-ziplist-entries']             = 128
default['redis']['config']['zset-max-ziplist-value']               = 64
default['redis']['config']['activerehashing']                      = 'yes'
default['redis']['config']['client-output-buffer-limit']['normal'] = '0 0 0'
default['redis']['config']['client-output-buffer-limit']['slave']  = '256mb 64mb 60'
default['redis']['config']['client-output-buffer-limit']['pubsub'] = '32mb 8mb 60'
default['redis']['config']['hz']                                   = 10
default['redis']['config']['aof-rewrite-incremental-fsync']        = 'yes'

# Default autoredisbackup config
default['autoredisbackup']['config']['backupdir']   = '/var/backups/redis'
default['autoredisbackup']['config']['mailcontent'] = 'log'
default['autoredisbackup']['config']['mailaddr']    = 'root'
default['autoredisbackup']['config']['doweekly']    = 6
default['autoredisbackup']['config']['latest']      = 'no'

# Prometheus redis_exporter
default['prometheus_exporters']['redis']['install']  = false
default['prometheus_exporters']['redis']['version']  = '1.35.1'
default['prometheus_exporters']['redis']['url']      = "https://github.com/oliver006/redis_exporter/releases/download/v#{node['prometheus_exporters']['redis']['version']}/redis_exporter-v#{node['prometheus_exporters']['redis']['version']}.linux-amd64.tar.gz"
default['prometheus_exporters']['redis']['checksum'] = '0b4eaaa85d0887f5ebc7c44cd8d67485298ede19f1537a81f4f94eed2f75701b'
