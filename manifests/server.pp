class dns::server {
  Class['dns::server'] <- Class['dns']
  class{'::dns::server::install':}->
  class{'::dns::server::config':}~>
  class{'::dns::server::service':}
}
