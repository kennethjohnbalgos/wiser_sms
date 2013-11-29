require "open-uri"
module WiserSms
  class Ph
    URL_HOST    = "http://121.97.123.218:13013/cgi-bin/sendsms"
    PASSWORD    = "kiko"
    GLOBE_USER  = "globegateway"
    GLOBE_MIN   = "09179409199"
    SMART_USER  = "smartgateway"
    SMART_MIN   = "09236357076"
    SUN_USER  = "sungateway"
    SUN_MIN   = "09328007170"

    def self.get_network?(min)
      return nil if min.size != 11
      prefix = min.to_s[0..3]
      if ['0813', '0907', '0908', '0909', '0910', '0912', '0918', '0919', '0920', '0921', '0928', '0929', '0930', '0938', '0939', '0946', '0947', '0948', '0949', '0989', '0998', '0999'].include?(prefix)
      	return "smart"
      elsif ['0817', '0905', '0906', '0915', '0916', '0917', '0926', '0927', '0935', '0936', '0937', '0994', '0996', '0997'].include?(prefix)
        return "globe"
      elsif ['0922', '0923', '0925', '0932', '0933', '0934', '0942', '0943'].include?(prefix)
        return "sun"
      else
        return "invalid"
      end
    end

    def self.escape(msg)
      return CGI::escape(msg)
    end

    def self.send(mins, msg)
      mins = [mins] unless mins.is_a?(Array)
      escaped_msg = self.escape(msg)
      response = {}
      mins.each do |min|
        case self.get_network?(min)
        when "globe"
          resp = self.send_globe(min, escaped_msg)
        when "smart"
          resp = self.send_smart(min, escaped_msg)
        when "sun"
          resp = self.send_sun(min, escaped_msg)
        else
          resp = nil
        end
        response[min] = resp
      end
      return response
    end

    def self.send_globe(min, msg)
      return nil if min.size != 11
      auth = "?username=#{GLOBE_USER}&password=#{PASSWORD}"
      params = "&from=#{GLOBE_MIN}&to=#{min}&text=#{msg}"
      return self.request(auth, params)
    end

    def self.send_smart(min, msg)
      return nil if min.size != 11
      auth = "?username=#{SMART_USER}&password=#{PASSWORD}"
      params = "&from=#{SMART_MIN}&to=#{min}&text=#{msg}"
      return self.request(auth, params)
    end

    def self.send_sun(min, msg)
      return nil if min.size != 11
      auth = "?username=#{SUN_USER}&password=#{PASSWORD}"
      params = "&from=#{SUN_MIN}&to=#{min}&text=#{msg}"
      return self.request(auth, params)
    end

    def self.request(auth, params)
      begin
        response = open("#{URL_HOST}#{auth}#{params}").read
        return response.split(":")[0] == "0"
      rescue
        return false
      end
    end
  end
end
