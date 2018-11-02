define dns::record::a (
  $zone,
  $data,
  $ttl = '',
  $ptr = false,
  $host = $name,
  $netmask = 24,
) {

  $alias = "${host},A,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $host,
    ttl  => $ttl,
    data => $data
  }

  if $ptr {
    $ip = inline_template('<%= @data.kind_of?(Array) ? @data.first : @data %>')
    $reverse_zone = inline_template("<%= require 'ipaddr'; IPAddr.new(@ip).reverse.split('.')[1..-1].join('.') %>")
    $last_octet = inline_template("<%= @ip.split('.').last %>")

    dns::record::ptr { "${host}.${zone}":
      host => $last_octet,
      zone => $reverse_zone,
      data => "${host}.${zone}"
    }
  }
}
