
module Bixby
  module ThreadDump

    class LoggerIO
      def initialize(logger)
        @logger = logger
      end
      def puts(str="")
        @logger.warn(str)
      end
    end

    class << self

      # Prints a thread dump on ALRM signal
      # kill -ALRM <pid>
      #
      # You can cancel the signal trap by saving the returned Thread and killing it
      # @param [IO] logger        IO-like destination for thread dumps (responds to #puts)
      #
      # @return [Thread]
      def trap!(logger=nil)

        if logger.nil? then
          logger = STDERR
        elsif Module.const_defined?(:Logging) && logger.kind_of?(Logging::Logger) then
          logger = LoggerIO.new(logger)
        end

        t = Bixby::Signal.trap("SIGALRM") do
          write(logger)
        end
        t[:_name] = "dumper [ignore me]"

        logger.puts("Trapping SIGALRM: kill -ALRM #{Process.pid}")
        return t
      end

      # Write thread dump to the given IO-like handle (must respond to #puts)
      #
      # @param [IO] io
      def write(io=STDERR)
        out = []
        out << "=== thread dump for #{$0} (pid=#{Process.pid}): #{Time.now} ==="
        out << ""

        Thread.list.each do |thread|

          # compute thread name, filling in some common libraries
          n = thread.inspect
          if thread.key?(:_name) then
            n += " #{thread[:_name]}"
          else
            t = thread.backtrace.first.strip
            if t =~ %r{rack/handler/puma.rb:.*`join'} then
              n += " puma daemon thread"
            elsif t =~ %r{puma/reactor.rb:.*`select'} then
              n += " puma runloop"
            elsif t =~ %r{puma/server.rb:.*`select'} then
              n += " puma i/o runloop"
            elsif t =~ %r{puma/thread_pool.rb:.*`sleep'} then
              n += " puma threadpool cleanup"
            elsif t =~ %r{lib/eventmachine.rb:.*`run_machine'} then
              n += " EventMachine runloop"
            elsif t =~ %r{celluloid/mailbox.rb:.*`sleep'} then
              n += " celluloid actor thread"
            elsif t =~ %r{bixby-common/util/thread_pool/worker.rb:.*} then
              state = (t =~ /`pop'/ ? "idle" : "busy")
              n += " Bixby::ThreadPool::Worker thread, #{state}"
            end
          end

          out << n
          out << "  " + thread.backtrace.join("\n    \\_ ")
          out << "-"
          out << ""
        end
        out << "=== end thread dump ==="

        io.puts out.join("\n")
      end

    end
  end
end
