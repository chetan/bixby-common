
module Bixby
  class CommandException < Exception

    attr_accessor :response

    def initialize(message, command_response)
      super(message)
      @response = command_response
    end

  end
end
