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
  $zone_file_stage = "${zone_file}.stage"

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } else {
    # Create "fake" zone file without zone-serial
    concat { $zone_file_stage:
      owner   => $::dns::user_name,
      group   => $::dns::user_name,
      mode    => '0644',
      require => [Class['concat::setup'], Class['dns::server']],
      notify  => Exec["bump-${zone}-serial"]
    }
    concat::fragment{"db.${name}.soa":
      target  => $zone_file_stage,
      order   => 1,
      content => template("${module_name}/zone_file.erb")
    }

    # Generate real zone from stage file through replacement _SERIAL_ template
    # to current timestamp. A real zone file will be updated only at change of
    # the stage file, thanks to this serial is updated only in case of need.
    $zone_serial = $serial ? {
      false   => inline_template('<%= Time.now.to_i %>'),
      default => $serial,
  }
    exec { "bump-${zone}-serial":
      command     => "sed '8s/_SERIAL_/${zone_serial}/' ${zone_file_stage} > ${zone_file}",
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      provider    => posix,
      user        => $::dns::user_name,
      group       => $::dns::user_name,
      require     => Class['dns::server::install'],
      notify      => Class['dns::server::service'],
    }
  }

  # Include Zone in named.conf.local
  concat::fragment{"named.conf.local.${name}.include":
    ensure  => $ensure,
    target  => $::dns::named_conf_local,
    order   => 2,
    content => template("${module_name}/zone.erb")
  }

}
