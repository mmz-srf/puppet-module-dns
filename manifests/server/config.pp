class dns::server::config {

  case $operatingsystem {
    centos, redhat: {
      $bind_service_name = 'named'
      $bind_user_name = 'named'
      $bind_conf_dir = '/etc/named'
    }
    ubuntu, debian: {
      $bind_service_name = 'bind9'
      $bind_user_name = 'bind'
      $bind_conf_dir = '/etc/bind'
    }
  }

  file { "${bind_conf_dir}":
    ensure => directory,
    owner  => $bind_user_name,
    group  => $bind_user_name,
    mode   => 0755,
  }

  file { "${bind_conf_dir}/named.conf":
    ensure  => present,
    owner   => $bind_user_name,
    group   => $bind_user_name,
    mode    => 0644,
    require => [File["${bind_conf_dir}"], Class['dns::server::install']],
    notify  => Class['dns::server::service'],
  }

  concat { "${bind_conf_dir}/named.conf.local":
    owner   => $bind_user_name,
    group   => $bind_user_name,
    mode    => 0644,
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "${bind_conf_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

}
