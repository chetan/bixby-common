
require 'helper'

module Bixby
module Test

class TestCryptoUtil < TestCase

  def test_crypto_cycle

    key1 = CryptoUtil.generate_keypair
    key2 = CryptoUtil.generate_keypair

    data = {"foo" => "bar"}
    uuid = "123456"

    encrypted = CryptoUtil.encrypt(MultiJson.dump(data), uuid, key1, key2)
    assert encrypted
    encrypted_io = StringIO.new(encrypted)
    assert_equal uuid, encrypted_io.readline.strip

    decrypted = CryptoUtil.decrypt(encrypted_io, key1, key2)
    assert decrypted
    data_out = MultiJson.load(decrypted)
    assert data_out
    assert_kind_of Hash, data_out
    assert_equal "bar", data_out["foo"]
  end


end # TestCryptoUtil

end # Test
end # Bixby
