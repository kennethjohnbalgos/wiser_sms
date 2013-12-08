require 'openssl'
require 'open-uri'
require 'cgi'

module WiserSms
  class Ph
    ADDRESS     = "121.97.123.218:13013"
    VTR         = "9a3a70173b00fd265aa0a9b79163a5bb1f0e157b"
    PASSWORD    = "zEQBwfcPD9RsB6OqBGLAVg==\n"
    GLOBE_USER  = "ydbrX+oiguoLAWKAGsWHyg==\n"
    GLOBE_MIN   = "9L9UYGiJiZku+m7lZgsGBg==\n"
    SMART_USER  = "xOhnX3pSw02OJ6FzD2LyCQ==\n"
    SMART_MIN   = "k9rGz/TMCiZZOmJT8S6yFg==\n"
    SUN_USER    = "xIIXdSOgjnpGUT8Baqum9A==\n"
    SUN_MIN     = "tigoy2Tzx6OiVKuyMZ5ViQ==\n"

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

    def self.send(key, mins, msg)
      return 0 unless key.to_s.strip.present?
      mins = [mins] unless mins.is_a?(Array)
      escaped_msg = self.escape(msg)
      response = {}
      mins.each do |min|
        case self.get_network?(min)
        when "globe"
          resp = self.send_globe(key, min, escaped_msg)
        when "smart"
          resp = self.send_smart(key, min, escaped_msg)
        when "sun"
          resp = self.send_sun(key, min, escaped_msg)
        else
          resp = nil
        end
        return resp
        response[min] = resp
      end
      return response
    end

    def self.send_globe(key, min, msg)
      return nil if min.size != 11
      user = GLOBE_USER
      pass = PASSWORD
      src  = GLOBE_MIN
      return self.request(key, user, pass, src, min, msg)
    end

    def self.send_smart(key, min, msg)
      return nil if min.size != 11
      user = SMART_USER
      pass = PASSWORD
      src  = SMART_MIN
      return self.request(key, user, pass, src, min, msg)
    end

    def self.send_sun(key, min, msg)
      return nil if min.size != 11
      user = SUN_USER
      pass = PASSWORD
      src  = SUN_MIN
      return self.request(key, user, pass, src, min, msg)
    end

    def self.request(key, username, password, source, destination, message)
      begin
        username  = self.validate(key, username)
        password  = self.validate(key, password)
        source    = self.validate(key, source)

        url       = "http://#{ADDRESS}/cgi-bin/sendsms"
        authorize = "?username=#{username}&password=#{password}&from=#{source}"
        payload   = "&to=#{destination}&text=#{message}"
        request   = "#{url}#{authorize}#{payload}"
        response  = open(request).read
        return response.split(":")[0] == "0"
      rescue
        return 0
      end
    end

    def self.encrypt(key, str)
      aes = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      aes.encrypt
      aes.key = key
      aes.iv = VTR
      cipher = aes.update(str)
      cipher = aes.final
      enc = [cipher].pack('m')
      return enc
    end

    def self.validate(key, str)
      aes = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      aes.decrypt
      aes.key = key
      aes.iv = VTR
      cipher = aes.update(str.unpack('m')[0])
      cipher << aes.final
      return cipher
    end
  end
end
