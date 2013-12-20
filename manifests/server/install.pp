class dns::server::install {

  case $operatingsystem {
    centos, redhat: {
      package { ['bind','bind-utils']:
        ensure => latest,
      }
    }
    ubuntu, debian: {
      package { ['bind9','bind9utils']:
       ensure => latest,
      }
    }
  }

}
