class dns::params {

  $named_conf = 'modules/dns/named.conf.erb'

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
    }
  }

}
