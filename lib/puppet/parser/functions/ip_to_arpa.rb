require 'ipaddr'

def convert(ip, mask)
  IPAddr.new(ip).mask(mask).to_range.collect do|ip|
    ip.to_s.split('.')[0..-2].join('.')
  end.uniq.collect do |ip|
    IPAddr.new(ip+'.0').reverse.split('.')[1..-1].join('.')
  end
end

module Puppet::Parser::Functions
  newfunction(:ip_to_arpa, :type => :rvalue) do |args|
    if args[0].kind_of?(Array)
      args[0].collect{|ip| convert(ip, args[1]) }
    else
      convert(args[0], args[1])
    end
  end
end
