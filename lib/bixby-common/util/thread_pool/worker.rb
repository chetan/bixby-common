
require "timeout"

module Bixby
  class ThreadPool
    class Worker

      include Bixby::Log

      attr_reader :thread

      def initialize(queue, idle_timeout, exit_handler)
        @input_queue = queue
        @idle_timeout = idle_timeout
        @exit_handler = exit_handler
        @running = true
        @working = false
        @thread = Thread.new { start_run_loop }
      end

      def join(max_wait = nil)
        raise "Worker can't join itself." if @thread == Thread.current

        return true if @thread.nil? || !@thread.join(max_wait).nil?

        @thread.kill and return false
      end

      def alive?
        return @running && @thread && @thread.alive?
      end

      def working?
        @working
      end

      def inspect
        return "#<#{self.class.to_s}:0x#{(object_id << 1).to_s(16)} #{alive? ? 'alive' : 'dead'}>"
      end

      def to_s
        inspect
      end


      private

      def start_run_loop
        begin

          while true

            task = nil
            Timeout::timeout(@idle_timeout) {
              task = @input_queue.pop
            }

            case task.command
              when :shutdown
                # logger.debug "#{inspect} thread shutting down"
                task.block.call(self) if task.block
                @running = false
                @thread = nil
                return nil
              when :perform
                @working = true
                # logger.debug "#{inspect} got work"
                task.block.call if task.block
                @working = false
            end
          end

        rescue Timeout::Error => ex
          if @exit_handler.call(self, :timeout) then
            # true result means we should exit
            # logger.debug "worker exiting due to idle timeout (#{@idle_timeout} sec)"
            @running = false
            return
          end

        rescue Exception => e
          @running = false
          logger.error "Worker runloop died: #{e.message}\n" + e.backtrace.join("\n")
          @exit_handler.call(self, :exception)
        end
      end

    end
  end
end
