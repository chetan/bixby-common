
require 'base64'
require 'openssl'
require 'digest'

module Bixby
  module CryptoUtil

    class << self

      # Encrypt the given payload for over-the-wire transmission
      #
      # @param [Object] data                    payload, usually a JSON-encoded String
      # @param [String] uuid                    UUID of the sender
      # @param [OpenSSL::PKey::RSA] key_pem     Public key of the receiver
      # @param [OpenSSL::PKey::RSA] iv_pem      Private key of the sender
      def encrypt(data, uuid, key_pem, iv_pem)
        c = new_cipher()
        c.encrypt
        key = c.random_key
        iv = c.random_iv

        data = Time.new.to_i.to_s + "\n" + data # prepend timestamp
        encrypted = c.update(data) + c.final

        out = []
        out << uuid
        out << create_hmac(key, iv, encrypted)
        out << w( key_pem.public_encrypt(key) )
        out << w( iv_pem.private_encrypt(iv) )
        out << e64(encrypted)

        return out.join("\n")
      end

      # Decrypt the given payload from over-the-wire transmission
      #
      # @param [Object] data                    encrypted payload, usually a JSON-encoded String
      # @param [OpenSSL::PKey::RSA] key_pem     Private key of the receiver
      # @param [OpenSSL::PKey::RSA] iv_pem      Public key of the sender
      def decrypt(data, key_pem, iv_pem)
        data = StringIO.new(data, 'rb') if not data.kind_of? StringIO
        hmac = data.readline.strip
        key = key_pem.private_decrypt(read_next(data))
        iv  = iv_pem.public_decrypt(read_next(data))

        c = new_cipher()
        c.decrypt
        c.key = key
        c.iv = iv

        payload = d64(data.read)

        # very hmac of encrypted payload
        if not verify_hmac(hmac, key, iv, payload) then
          raise Bixby::EncryptionError, "hmac verification failed", caller
        end

        data = StringIO.new(c.update(payload) + c.final)

        ts = data.readline.strip
        if (Time.new.to_i - ts.to_i) > 60 then
          raise Bixby::EncryptionError, "payload verification failed", caller
        end

        return data.read
      end


      private

      # Compute an HMAC using SHA2-256
      #
      # @param [String] key
      # @param [String] iv
      # @param [String] payload     encrypted payload
      #
      # @return [String] digest in hexadecimal format
      def create_hmac(key, iv, payload)
        d = Digest::SHA2.new(256)
        d << key << iv << payload
        return d.hexdigest()
      end

      # Verify the given HMAC of the incoming message
      #
      # @param [String] hmac
      # @param [String] key
      # @param [String] iv
      # @param [String] payload     encrypted payload
      #
      # @return [Boolean] true if hmac matches
      def verify_hmac(hmac, key, iv, payload)
        create_hmac(key, iv, payload) == hmac
      end

      def new_cipher
        # TODO make this configurable? perhaps use CTR when available
        # we can store a CTR support flag on the master
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
