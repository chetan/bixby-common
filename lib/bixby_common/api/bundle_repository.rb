
# path should be initialized on Agent or Manager start

module Bixby

  class BundleRepository < BaseModule
    class << self
      attr_accessor :path
    end
  end # BundleRepository

end # Bixby
