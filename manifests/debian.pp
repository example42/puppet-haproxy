class haproxy::debian {
  # Enable service start
  file { 'default-haproxy':
    ensure  => $haproxy::manage_file,
    path    => $haproxy::config_file_init,
    require => Package[haproxy],
    content => template('haproxy/default.init-debian'),
    mode    => $haproxy::config_file_mode,
    owner   => $haproxy::config_file_owner,
    group   => $haproxy::config_file_group,
    notify  => $haproxy::manage_service_autorestart,
  }
}
