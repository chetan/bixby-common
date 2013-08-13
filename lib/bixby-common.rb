
# TODO temp fix to make sure we use oj
require "oj"
require "multi_json"

require "bixby_common/bixby"

module Bixby

  autoload :CommandResponse, "bixby_common/command_response"
  autoload :CommandSpec, "bixby_common/command_spec"

  autoload :JsonRequest, "bixby_common/api/json_request"
  autoload :JsonResponse, "bixby_common/api/json_response"

  autoload :BundleNotFound, "bixby_common/exception/bundle_not_found"
  autoload :CommandNotFound, "bixby_common/exception/command_not_found"
  autoload :CommandException, "bixby_common/exception/command_exception"
  autoload :EncryptionError, "bixby_common/exception/encryption_error"

  autoload :CryptoUtil, "bixby_common/util/crypto_util"
  autoload :HttpClient, "bixby_common/util/http_client"
  autoload :Jsonify, "bixby_common/util/jsonify"
  autoload :Hashify, "bixby_common/util/hashify"
  autoload :Log, "bixby_common/util/log"
  autoload :Debug, "bixby_common/util/debug"

end
