
module Bixby

  autoload :CommandResponse, "bixby_common/command_response"
  autoload :CommandSpec, "bixby_common/command_spec"

  autoload :JsonRequest, "bixby_common/api/json_request"
  autoload :JsonResponse, "bixby_common/api/json_response"

  autoload :BaseModule, "bixby_common/api/modules/base_module"
  autoload :BundleRepository, "bixby_common/api/modules/bundle_repository"

  autoload :BundleNotFound, "bixby_common/exception/bundle_not_found"
  autoload :CommandNotFound, "bixby_common/exception/command_not_found"

  autoload :HttpClient, "bixby_common/util/http_client"
  autoload :Jsonify, "bixby_common/util/jsonify"
  autoload :Hashify, "bixby_common/util/hashify"

end