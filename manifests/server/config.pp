class dns::server::config {

  file { "${::dns::conf_dir}":
    ensure => directory,
    owner  => $::dns::user_name,
    group  => $::dns::user_name,
    mode   => 0755,
    require => Class['dns::server::install'],
  }

  file { $::dns::named_conf:
    ensure  => present,
    owner   => $::dns::user_name,
    group   => $::dns::user_name,
    mode    => 0644,
    content => template($::dns::named_conf_template),
    require => File["${::dns::conf_dir}"],
    notify  => Class['dns::server::service'],
  }

  case $operatingsystem {
    ubunut, debian: {
      file{ $::dns::named:conf_options:
        ensure  => present,
        owner   => $::dns::user_name,
        group   => $::dns::user_name,
        mode    => 0644,
        content => template($::dns::named_conf_options_template),
        require => File["${::dns::conf_dir}"],
        notify  => Class['dns::server::service'],
      }
    }
  }

  concat { $dns::named_conf_local:
    owner   => $::dns::user_name,
    group   => $::dns::user_name,
    mode    => 0644,
    require => [
      Class['concat::setup'],
      Class['dns::server::install'],
    ],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => $dns::named_conf_local,
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

}
