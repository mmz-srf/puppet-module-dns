class dns::server::install {

  case $operatingsystem {
    centos, redhat: {
      $package_name = 'bind'
    }
    ubuntu, debian: {
      $package_name = 'bind9'
    }
  }

  package { 'bind9':
    name => $package_name,
    ensure => latest,
  }

}
