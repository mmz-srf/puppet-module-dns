class dns (
  $service_name = $dns::params::service_name,
  $user_name = $dns::params::user_name,
  $conf_dir = $dns::params::conf_dir,
  $named_conf_template = $dns::params::named_conf_template
) inherits dns::params {
  include dns::server
}
