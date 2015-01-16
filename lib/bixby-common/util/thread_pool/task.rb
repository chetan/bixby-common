
module Bixby
  class ThreadPool
    class Task

      attr_accessor :command, :block

      def initialize(command, block=nil)
        @command = command
        @block   = block
      end

    end
  end
end
