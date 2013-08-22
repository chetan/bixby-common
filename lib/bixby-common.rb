
# TODO temp fix to make sure we use oj
require "oj"
require "multi_json"

require "bixby-common/bixby"

module Bixby

  autoload :CommandResponse, "bixby-common/command_response"
  autoload :CommandSpec, "bixby-common/command_spec"

  autoload :JsonRequest, "bixby-common/api/json_request"
  autoload :JsonResponse, "bixby-common/api/json_response"
  autoload :SignedJsonRequest, "bixby-common/api/signed_json_request"
  autoload :EncryptedJsonRequest, "bixby-common/api/encrypted_json_request"
  autoload :RpcHandler, "bixby-common/api/rpc_handler"
  autoload :HttpChannel, "bixby-common/api/http_channel"
  autoload :APIChannel, "bixby-common/api/api_channel"

  module WebSocket
    autoload :APIChannel, "bixby-common/websocket/api_channel"
    autoload :AsyncResponse, "bixby-common/websocket/async_response"
    autoload :Client, "bixby-common/websocket/client"
  end

  autoload :BundleNotFound, "bixby-common/exception/bundle_not_found"
  autoload :CommandNotFound, "bixby-common/exception/command_not_found"
  autoload :CommandException, "bixby-common/exception/command_exception"
  autoload :EncryptionError, "bixby-common/exception/encryption_error"

  autoload :CryptoUtil, "bixby-common/util/crypto_util"
  autoload :HttpClient, "bixby-common/util/http_client"
  autoload :Jsonify, "bixby-common/util/jsonify"
  autoload :Hashify, "bixby-common/util/hashify"
  autoload :Log, "bixby-common/util/log"
  autoload :Debug, "bixby-common/util/debug"

end
