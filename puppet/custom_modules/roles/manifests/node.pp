class roles::node {
  class{'nginx': }
  file { "/etc/nginx/sites-enabled/default-vhost.conf":
    content => template('roles/node/site.conf.erb'),
    require => Class['nginx'],
  }

  class { '::consul':
    config_hash => {
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'us-west',
      'log_level'        => 'DEBUG',
      'node_name'        => 'consul-127.0.0.1',
      'retry_join'       => ['consul-1c.jobtest.aws', 'consul-1a.jobtest.aws', 'consul.jobtest.aws'],
    }
  }

  ::consul::service { 'http':
    checks  => [
      {
        http     => 'http://localhost/',
        interval => '5s'
      }
    ],
    port    => 80,
  }
}
