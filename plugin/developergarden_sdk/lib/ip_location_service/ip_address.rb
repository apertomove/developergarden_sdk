module IpLocationService

  # Represents an ip address to be passed to the LocateIp-Operation of the IpLocation-Service.
  class IpAddress

    @@IP_V4 = 4
    @@IP_V6 = 6

    attr_accessor :ip_address, :ip_type

    # === Parameters
    # <tt>ip_address</tt>::
    # <tt>ip_type</tt>:: IP version of the given address. Valid options are :ipv4 and ipv6. Currently only :ipv4 is supported.    
    def initialize(ip_address, ip_type = @@IP_V4)
      @ip_address = ip_address
      @ip_type = ip_type
    end

    def to_s
      @ip_address.to_s
    end

    #### Class methods

    def self.IP_V4
      @@IP_V4
    end

    def self.IP_V6
      @@IP_V6
    end

    protected

    # === Parameters
    # <tt>ip_address</tt>:: ip_address as string or IpAddress object.
    def self.build_from_ip_address(from_ip_address)
      ret = nil
      if from_ip_address.is_a?(String)
        ret = new(from_ip_address)
      elsif from_ip_address.is_a?(IpAddress)
        ret = from_ip_address.dup
      else        
        raise("Unknown class #{from_ip_address.class.to_s} for ip address. Can be string or IpAddress.")
      end
      
      return ret
    end
  end
end