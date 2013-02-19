define dns::zone (
  $soa = "${::fqdn}.",
  $soa_email = "root.${::fqdn}.",
  $serial = false,
  $zone_ttl = '604800',
  $zone_refresh = '604800',
  $zone_retry = '86400',
  $zone_expire = '2419200',
  $zone_minimum = '604800',
  $nameservers = [ $::fqdn ],
  $zone_type = 'master',
  $zone_notify = false,
  $ensure = present
) {
  $zone = $name
  $zone_file = "${::dns::conf_dir}/db.${name}"
  $zone_serial = $serial ? {
    false   => inline_template('<%= Time.now.to_i %>'),
    default => $serial
  }

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } else {
    # Zone Database
    concat { $zone_file:
      owner   => $::dns::user_name, 
      group   => $::dns::user_name,
      mode    => 0644,
      require => [Class['concat::setup'], Class['dns::server::install']],
      notify  => Class['dns::server::service']
    }
    concat::fragment{"db.${name}.soa":
      target  => $zone_file,
      order   => 1,
      content => template("${module_name}/zone_file.erb")
    }
  }

  # Include Zone in named.conf.local
  concat::fragment{"named.conf.local.${name}.include":
    ensure  => $ensure,
    target  => "${::dns::conf_dir}/named.conf.local",
    order   => 2,
    content => template("${module_name}/zone.erb")
  }

}
