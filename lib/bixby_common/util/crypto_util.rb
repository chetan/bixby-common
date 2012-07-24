
require 'base64'
require 'openssl'

module Bixby
  module CryptoUtil

    class << self

      def encrypt(data, key_pem, iv_pem)
        c = new_cipher()
        c.encrypt
        key = c.random_key
        iv = c.random_iv
        encrypted = c.update(data) + c.final

        out = []
        out << w( key_pem.public_encrypt(key) )
        out << w( iv_pem.private_encrypt(iv) )
        out << e64(encrypted)

        return out.join("\n")
      end

      def decrypt(data, key_pem, iv_pem)
        data = StringIO.new(data, 'rb')
        key = key_pem.private_decrypt(read_next(data))
        iv  = iv_pem.public_decrypt(read_next(data))

        c = new_cipher()
        c.decrypt
        c.key = key
        c.iv = iv

        ret = c.update(d64(data.read)) + c.final
      end


      private

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
