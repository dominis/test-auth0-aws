class roles::proxy {
  class{'nginx': }

  class { '::consul':
    config_hash => {
      'data_dir'         => '/opt/consul',
      'datacenter'       => 'us-west',
      'log_level'        => 'DEBUG',
      'node_name'        => 'consul-127.0.0.1',
      'server'           => true,
      'bootstrap_expect' => 2,
      'retry_join'       => ['consul-1c.jobtest.aws', 'consul-1a.jobtest.aws', 'consul.jobtest.aws'],
    }
  }

  class { 'consul_template':
    service_enable   => false,
    manage_user      => true,
    manage_group     => true,
    log_level        => 'debug',
    consul_wait      => '5s:30s',
    consul_max_stale => '10m',
  }

  # this is needed to start nginx
  file { "/etc/nginx/sites-enabled/default-vhost.conf":
    content => template('roles/proxy/site.conf.erb'),
    require => Class['nginx'],
  }

  consul_template::watch { 'nginx-site.conf':
    template      => 'roles/proxy/site.conf.ctpl.erb',
    destination   => '/etc/nginx/sites-enabled/default-vhost.conf',
    command       => '/etc/init.d/nginx start',
  }

  # consul-template dies before consul even start
  cron { 'this is not cool':
    command => "/etc/init.d/consul-template start",
    user    => root,
  }
}
