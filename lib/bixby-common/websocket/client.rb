
require 'faye/websocket'
require 'eventmachine'

module Bixby
  module WebSocket

    # WebSocket Client
    class Client

      include Bixby::Log

      attr_reader :ws, :api

      def initialize(url)
        @url = url
        @tries = 0
        @exiting = false
      end

      # Start the Client thread
      #
      # NOTE: This call never returns!
      def start

        Kernel.trap("EXIT") do
          @exiting = true
        end

        EM.run {
          reconnect()
        }
      end

      # Connect to the WebSocket endpoint given by @url. Will attempt to keep
      # the connection open forever, reconnecting as needed.
      def reconnect
        @ws = Faye::WebSocket::Client.new(@url)
        @api = Bixby::WebSocket::API.new(@ws)

        ws.on :open do |e|
          begin
            api.open(e)
            @tries = 0
          rescue Exception => ex
            logger.error ex
          end
        end

        ws.on :message do |e|
          begin
            api.message(e)
          rescue Exception => ex
            logger.error ex
          end
        end

        ws.on :close do |e|
          begin
            api.close(e)
            backoff()
            reconnect()
          rescue Exception => ex
            logger.error ex
          end
        end
      end

      # Delay reconnection by a slowly increasing interval
      def backoff
        return if @exiting # shutting down, don't try to reconnect
        @tries += 1
        if @tries == 1 then
          logger.debug "retrying immediately"
        elsif @tries == 2 then
          logger.debug "retrying every 1 sec"
          sleep 1
        elsif @tries <= 30 then
          sleep 1
        elsif @tries == 31 then
          logger.debug "retrying every 5 sec"
          sleep 5
        else
          sleep 5
        end
      end

    end

  end
end
