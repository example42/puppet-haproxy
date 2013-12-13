#
# = Class: haproxy
#
# This class installs and manages haproxy
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class haproxy (

  $package_name              = $haproxy::params::package_name,
  $package_ensure            = 'present',

  $service_name              = $haproxy::params::service_name,
  $service_ensure            = 'running',
  $service_enable            = true,

  $config_file_path          = $haproxy::params::config_file_path,
  $config_file_require       = 'Package[haproxy]',
  $config_file_notify        = 'Service[haproxy]',
  $config_file_source        = undef,
  $config_file_template      = undef,
  $config_file_content       = undef,
  $config_file_options_hash  = { } ,

  $init_file_path            = $haproxy::params::init_file_path,
  $init_file_template        = $haproxy::params::init_file_template,

  $config_dir_path           = $haproxy::params::config_dir_path,
  $config_dir_source         = undef,
  $config_dir_purge          = false,
  $config_dir_recurse        = true,

  $conf_hash                 = undef,

  $dependency_class          = undef,
  $my_class                  = undef,

  $monitor_class             = undef,
  $monitor_options_hash      = { } ,

  $firewall_class            = undef,
  $firewall_options_hash     = { } ,

  $scope_hash_filter         = '(uptime.*|timestamp)',

  $tcp_port                  = undef,
  $udp_port                  = undef,

  ) inherits haproxy::params {


  # Class variables validation and management

  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }

  $config_file_owner          = $haproxy::params::config_file_owner
  $config_file_group          = $haproxy::params::config_file_group
  $config_file_mode           = $haproxy::params::config_file_mode

  $manage_config_file_content = default_content($config_file_content, $config_file_template)

  $manage_config_file_notify  = $config_file_notify ? {
    'class_default' => 'Service[haproxy]',
    ''              => undef,
    default         => $config_file_notify,
  }

  if $package_ensure == 'absent' {
    $manage_service_enable = undef
    $manage_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $manage_service_enable = $service_enable ? {
      ''      => undef,
      'undef' => undef,
      default => $service_enable,
    }
    $manage_service_ensure = $service_ensure ? {
      ''      => undef,
      'undef' => undef,
      default => $service_ensure,
    }
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Dependency class

  if $haproxy::dependency_class {
    include $haproxy::dependency_class
  }


  # Resources managed

  if $haproxy::package_name {
    package { 'haproxy':
      ensure   => $haproxy::package_ensure,
      name     => $haproxy::package_name,
    }
  }

  if $haproxy::config_file_path {
    file { 'haproxy.conf':
      ensure  => $haproxy::config_file_ensure,
      path    => $haproxy::config_file_path,
      mode    => $haproxy::config_file_mode,
      owner   => $haproxy::config_file_owner,
      group   => $haproxy::config_file_group,
      source  => $haproxy::config_file_source,
      content => $haproxy::manage_config_file_content,
      notify  => $haproxy::manage_config_file_notify,
      require => $haproxy::config_file_require,
    }
  }

  if $haproxy::init_file_path {
    file { 'haproxy.conf.init':
      ensure  => $haproxy::manage_file,
      path    => $haproxy::init_file_path,
      require => $haproxy::config_file_require,
      content => template($haproxy::init_file_template),
      mode    => $haproxy::config_file_mode,
      owner   => $haproxy::config_file_owner,
      group   => $haproxy::config_file_group,
      notify  => $haproxy::config_file_notify,
    }
  }

  if $haproxy::config_dir_source {
    file { 'haproxy.dir':
      ensure  => $haproxy::config_dir_ensure,
      path    => $haproxy::config_dir_path,
      source  => $haproxy::config_dir_source,
      recurse => $haproxy::config_dir_recurse,
      purge   => $haproxy::config_dir_purge,
      force   => $haproxy::config_dir_purge,
      notify  => $haproxy::manage_config_file_notify,
      require => $haproxy::config_file_require,
    }
  }

  if $haproxy::service_name {
    service { 'haproxy':
      ensure     => $haproxy::manage_service_ensure,
      name       => $haproxy::service_name,
      enable     => $haproxy::manage_service_enable,
    }
  }


  # Extra classes

  if $conf_hash {
    create_resources('haproxy::conf', $conf_hash)
  }

  if $haproxy::my_class {
    include $haproxy::my_class
  }

  if $haproxy::monitor_class {
    class { $haproxy::monitor_class:
      options_hash => $haproxy::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $haproxy::firewall_class {
    class { $haproxy::firewall_class:
      options_hash => $haproxy::firewall_options_hash,
      scope_hash   => {},
    }
  }

}

