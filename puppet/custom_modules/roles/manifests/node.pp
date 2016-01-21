class roles::node {
  class{'nginx': }
  file { "/etc/nginx/sites-enabled/default-vhost.conf":
    content => template('roles/node/site.conf.erb'),
    require => Class['nginx'],
  }
}
