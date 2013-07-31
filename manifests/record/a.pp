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
    $ip = inline_template('<%= data.kind_of?(Array) ? data.first : data %>')
    $reverse_zone = ip_to_arpa($ip, $netmask)
    $octet = inline_template('<%= ip.split(".")[-1] %>')

    dns::record::ptr { "${host}.${zone}":
      host => $octet,
      zone => $reverse_zone,
      data => "${host}.${zone}"
    }
  }
}
