# Class: haproxy::params
#
# Defines all the variables used in the module.
#
class haproxy::params {

  $package_name = $::osfamily ? {
    default => 'haproxy',
  }

  $service_name = $::osfamily ? {
    default => 'haproxy',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/haproxy/haproxy.cfg',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/haproxy',
  }

  $init_file_path = $::osfamily ? {
    debian  => '/etc/default/haproxy',
    default => false,
  }

  $init_file_template = $::osfamily ? {
    debian  => 'haproxy/default.init-debian',
    default => false,
  }


  case $::osfamily {
    'Debian','RedHat','Amazon': { }
    default: {
      fail("${::operatingsystem} not supported. Review params.pp for extending support.")
    }
  }
}
