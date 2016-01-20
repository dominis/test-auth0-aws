class roles::node {
  class{'nginx':
    manage_repo => true,
    package_source => 'nginx-mainline',
  }
  file { "/etc/nginx/sites-enabled/default-vhost.conf":
    content => template('roles/node/site.conf.erb'),
    require => Class['nginx'],
  }
}
