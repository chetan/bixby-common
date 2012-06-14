
module Bixby
  class BaseModule

    class << self
      attr_accessor :agent, :manager_uri

      include HttpClient
    end

  end # BaseModule
end # Bixby
