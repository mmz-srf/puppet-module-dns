class dns::params {

  $named_conf_template = 'dns/named.conf.erb'

  case $operatingsystem {
    centos, redhat: {
      # use top scope variable if it's defined, fallback to hardcoded value
      $service_name = $::dns_service_name ? {
        undef   => 'named',
        default => $::dns_service_name,
      }
      $user_name = $::dns_user_name ? {
        undef   => 'named',
        default => $::dns_user_name,
      }
      $conf_dir = $::dns_conf_dir ? {
        undef   => '/etc/named',
        default => $::dns_conf_dir,
      }
      $named_conf = $::dns_named_conf ? {
        undef   => '/etc/named.conf',
        default => $::dns_named_conf,
      }
      $named_conf_local = $::dns_named_conf_local ? {
        undef   => '/etc/named.conf.local',
        default => $::dns_named_conf_local,
      }
    }
    ubuntu, debian: {
      $service_name = $::dns_service_name ? {
        undef   => 'bind9',
        default => $::dns_service_name,
      }
      $user_name = $::dns_user_name ? {
        undef   => 'bind',
        default => $::dns_user_name,
      }
      $conf_dir = $::dns_conf_dir ? {
        undef   => '/etc/bind',
        default => $::dns_conf_dir,
      }
      $named_conf = $::dns_named_conf ? {
        undef   => "${conf_dir}/named.conf",
        default => $::dns_named_conf,
      }
      $named_conf_local = $::dns_named_conf_local ? {
        undef   => "${conf_dir}/named.conf.local",
        default => $::dns_named_conf_local,
      }
    }
  }

}
