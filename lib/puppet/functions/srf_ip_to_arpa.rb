# @summary N/A
Puppet::Functions.create_function(:srf_ip_to_arpa) do
  dispatch :srf_ip_to_arpa do
    repeated_param 'Any', :args
  end

  def srf_ip_to_arpa(*args)
    if args[0].kind_of?(Array)
      args[0].collect{|ip| srfconvert(ip, args[1]) }
    else
      srfconvert(args[0], args[1])
    end
  end

  def srfconvert(ip, mask)
    require 'ipaddr'
    IPAddr.new(ip).mask(mask).to_range.collect do|ip|
      ip.to_s.split('.')[0..-2].join('.')
    end.uniq.collect do |ip|
      IPAddr.new(ip+'.0').reverse.split('.')[1..-1].join('.')
    end
  end
end
