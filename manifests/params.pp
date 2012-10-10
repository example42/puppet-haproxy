# Class: haproxy::params
#
# This class defines default parameters used by the main module class haproxy
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to haproxy class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class haproxy::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'haproxy',
  }

  $service = $::operatingsystem ? {
    default => 'haproxy',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'haproxy',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'haproxy',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/haproxy',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/haproxy/haproxy.cfg',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/haproxy',
    default                   => '/etc/sysconfig/haproxy',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/haproxy.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '',
  }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    default => '',
  }

  $port = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '8443',
    default                   => '5000',
  }

  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $service_autorestart = true
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
