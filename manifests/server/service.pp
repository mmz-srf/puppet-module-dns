class dns::server::service {

  service { 'bind9':
    name       => $bind_service_name,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['dns::server::config']
  }

}