
module Bixby
  class EncryptedJsonRequest < JsonRequest

    def initialize(json_request, private_key, public_key, uuid="master")
      self.operation = json_request.operation
      self.params = json_request.params

      # encrypt
      data = json_request.to_json
      @body = Bixby::CryptoUtil.encrypt(data, uuid, public_key, private_key)
    end

    def to_wire
      @body
    end

  end
end
