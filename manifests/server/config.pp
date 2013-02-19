class dns::server::config {

  file { "${::dns::conf_dir}":
    ensure => directory,
    owner  => $::dns::user_name,
    group  => $::dns::user_name,
    mode   => 0755,
  }

  file { "${::dns::conf_dir}/named.conf":
    ensure  => present,
    owner   => $::dns::user_name,
    group   => $::dns::user_name,
    mode    => 0644,
    content => template($::dns::named_conf),
    require => [
      File["${::dns::conf_dir}"],
      Class['dns::server::install'],
    ],
    notify  => Class['dns::server::service'],
  }

  concat { "${::dns::conf_dir}/named.conf.local":
    owner   => $::dns::user_name,
    group   => $::dns::user_name,
    mode    => 0644,
    require => Class['concat::setup'],
    notify  => Class['dns::server::install']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "${::dns::conf_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

}
