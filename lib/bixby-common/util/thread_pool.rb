
# ThreadPool implementation based on MIT-licensed `workers` gem, v0.2.2, Copyright (c) 2013 Chad Remesch

require "bixby-common/util/thread_pool/task"
require "bixby-common/util/thread_pool/worker"

require "thread"
require "monitor"

module Bixby
  class ThreadPool

    DEFAULT_MIN = 1
    DEFAULT_MAX = 8
    DEFAULT_IDLE_TIMEOUT = 60

    include Bixby::Log

    def initialize(options = {})
      @input_queue = Queue.new
      @lock = Monitor.new
      @workers = []
      @min_size = options[:min_size] || DEFAULT_MIN
      @max_size = options[:max_size] || DEFAULT_MAX
      @idle_timeout = options[:idle_timeout] || DEFAULT_IDLE_TIMEOUT
      @size = 0

      expand(@min_size)
    end

    def enqueue(command, block=nil)
      logger.debug { "enqueue new task: #{command}" }
      @input_queue.push(Task.new(command, block))
      if command == :perform then
        grow
      end
      nil
    end

    def perform(&block)
      enqueue(:perform, block)
      nil
    end

    def <<(proc)
      enqueue(:perform, block)
      nil
    end

    def num_jobs
      @input_queue.size
    end

    def num_idle
      @size - num_busy
    end

    def num_busy
      @lock.synchronize do
        return @workers.find_all{ |w| w.working? }.size
      end
    end
    alias_method :num_working, :num_busy

    def shutdown(&block)
      @lock.synchronize do
        @size.times do
          enqueue(:shutdown, block)
        end
      end

      nil
    end

    def join(max_wait = nil)
      results = @workers.map { |w| w.join(max_wait) }
      @workers.clear
      @size = 0

      return results
    end

    def dispose
      @lock.synchronize do
        shutdown
        join
      end

      nil
    end

    def inspect
      "#<#{self.class.to_s}:0x#{(object_id << 1).to_s(16)} threads=#{size} jobs=#{num_jobs}>"
    end

    def to_s
      inspect
    end

    def size
      @lock.synchronize do
        return @size
      end
    end

    def expand(count)
      @lock.synchronize do
        logger.debug "expanding by #{count} threads (from #{@size})"
        count.times do
          create_worker
        end
      end

      nil
    end

    def contract(count, &block)
      @lock.synchronize do
        raise 'Count is too large.' if count > @size

        count.times do
          callback = Proc.new do |worker|
            remove_worker(worker)
            block.call if block
          end

          enqueue(:shutdown, callback)
        end
      end

      nil
    end

    def resize(new_size)
      @lock.synchronize do
        if new_size > @size
          expand(new_size - @size)
        elsif new_size < @size
          contract(@size - new_size)
        end
      end

      nil
    end

    # For debugging
    def summary
      @lock.synchronize do
        puts "jobs: #{@input_queue.size}"
        puts "workers: #{@workers.size}"
        @workers.each do |w|
          puts "  " + w.thread.inspect
        end
      end
    end


    private

    def create_worker
      @lock.synchronize do
        logger.debug "spawning new worker thread"

        exit_handler = lambda { |worker, reason|
          @lock.synchronize do
            if reason == :exception or (reason == :timeout && @size > @min_size) then
              remove_worker(worker)
              grow
              return true
            end
            false
          end
        }

        @workers << Worker.new(@input_queue, @idle_timeout, exit_handler)
        @size += 1
      end
    end

    # Grow the pool by one if we have more jobs than idle workers
    def grow
      @lock.synchronize do
        prune
        logger.debug { "jobs: #{num_jobs}; busy: #{num_working}; idle: #{num_idle}" }
        if @size == 0 || (@size < @max_size && num_jobs > 0 && num_jobs > num_idle) then
          space = @max_size-@size
          jobs = num_jobs-num_idle
          needed = space < jobs ? space : jobs
          needed = 1 if needed <= 0
          expand(needed)
        else
          logger.debug "NOT growing the pool!"
        end
      end

      nil
    end

    # Remove any dead worker threads which may not have been cleaned up properly
    # (via callback handler)
    def prune
      @lock.synchronize do
        @workers.delete_if { |w| !w.alive? }
        @size = @workers.size
      end
    end

    def remove_worker(worker)
      @lock.synchronize do
        @workers.delete(worker)
        @size -= 1
      end

      nil
    end
  end
end
