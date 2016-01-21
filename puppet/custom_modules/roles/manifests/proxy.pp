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
      'retry_join'       => ['127.0.0.1'],
    }
  }
}
