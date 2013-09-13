
module Bixby
  module Test

    class SideEffect
      def initialize(&block)
        @block = block
      end
      def perform
        @block.call
      end
    end

  end
end
