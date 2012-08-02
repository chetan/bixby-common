
require 'base64'
require 'openssl'
require 'digest'

module Bixby
  module CryptoUtil

    class << self

      def encrypt(data, uuid, key_pem, iv_pem)
        c = new_cipher()
        c.encrypt
        key = c.random_key
        iv = c.random_iv
        encrypted = c.update(data) + c.final

        out = []
        out << uuid
        out << create_hmac(data)
        out << w( key_pem.public_encrypt(key) )
        out << w( iv_pem.private_encrypt(iv) )
        out << e64(encrypted)

        return out.join("\n")
      end

      def decrypt(data, key_pem, iv_pem)
        data = StringIO.new(data, 'rb') if not data.kind_of? StringIO
        hmac = data.readline.strip
        key = key_pem.private_decrypt(read_next(data))
        iv  = iv_pem.public_decrypt(read_next(data))

        c = new_cipher()
        c.decrypt
        c.key = key
        c.iv = iv

        ret = c.update(d64(data.read)) + c.final

        if not verify_hmac(hmac, ret) then
          raise "hmac verification failed"
        end

        ret
      end


      private

      def create_hmac(payload)
        Digest::SHA2.new(256).hexdigest(payload)
      end

      def verify_hmac(hmac, payload)
        Digest::SHA2.new(256).hexdigest(payload) == hmac
      end

      def new_cipher
        OpenSSL::Cipher.new("AES-256-CBC")
      end

      def w(s)
        e64(s).gsub(/\n/, "\\n")
      end

      def read_next(data)
        d64(data.readline.gsub(/\\n/, "\n"))
      end

      def e64(s)
        Base64.encode64(s)
      end

      def d64(s)
        Base64.decode64(s)
      end

    end

  end # CryptoUtil
end # Bixby