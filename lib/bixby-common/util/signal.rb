
module Bixby
  module Signal

    # Helper for trapping signals and handling them via a dedicated thread
    #
    # @param [String] *signals         Signals to trap either as a space-separate string or array
    # @param [Block] block             Callback when signal is trapped
    #
    # @return [Thread]
    def self.trap(*signals, &block)
      sigs = signals.flatten.map{ |s| s.split(/[\s,]/) }.flatten.sort.uniq

      trap_r, trap_w = IO.pipe

      # handle signals from a dedicated thread
      handler_thread = Thread.new do
        while true
          sig = trap_r.readline.strip
          Thread.new do
            block.call(sig)
          end
        end
      end

      sigs.each do |sig|
        Kernel.trap(sig) do
          if handler_thread && handler_thread.alive? then
            # don't bother writing if the thread is dead
            trap_w.puts(sig)
          end
        end
      end

      return handler_thread
    end # trap

  end
end
