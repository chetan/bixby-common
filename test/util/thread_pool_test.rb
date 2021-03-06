
require 'helper'

module Bixby

  class ThreadPool
    def workers
      @workers
    end
  end

module Test
class TestThreadPool < TestCase

  def setup
    @pool = Bixby::ThreadPool.new(:idle_timeout => 1)
    assert_equal 1, @pool.size
    assert_equal 2, Thread.list.size
  end

  def teardown
    begin
      puts "tearing down, shutting down pool"
      @pool.shutdown
      @pool.join(0.1)
      assert_equal 0, @pool.size
    rescue Exception => ex
    end
  end

  def test_simple_job
    foo = []
    @pool.perform do
      foo << :bar
    end

    @pool.dispose
    logger.debug "pool disposed, joined"

    @pool.summary

    assert_equal 0, @pool.num_jobs, "no jobs left"
    assert_equal 1, foo.size
    assert_equal :bar, foo.first
  end

  def test_pool_grows_to_max
    foo = []
    4.times do |i|
      @pool.perform do
        logger.debug "running job #{i}, sleeping 10"
        sleep 10
        foo << "thread #{i}"
      end
      sleep 0.1
    end
    assert_equal 4, @pool.size

    10.times do |i|
      @pool.perform do
        sleep 10
        foo << "thread #{i}"
      end
    end
    assert_equal 8, @pool.size

    # assert_equal 14, foo.size
  end

  def test_pool_shrinks_on_idle
    foo = []
    2.times do |i|
      @pool.perform do
        foo << "thread #{i}"
      end
    end
    assert_equal 2, @pool.size, "pool should grow to 2"

    while @pool.num_busy > 0 do
      sleep 0.1
    end
    sleep 1.1

    logger.debug "shrank yet?!"
    assert_equal 1, @pool.size, "pool should shrink to 1"
  end

  def test_handle_exception
    @pool.perform do
      raise "bleh"
    end

    while @pool.num_busy > 0 || @pool.num_jobs > 0 do
      sleep 0.1
    end

    assert_equal 1, @pool.size
    assert_equal 0, @pool.workers.find_all{ |w| !w.thread.alive? }.size, "no dead threads"
  end

  def test_handle_killed_thread
    assert_equal 1, @pool.size
    assert @pool.workers.find{ |w| w.thread.alive? }
    @pool.workers.first.thread.kill
    sleep 0.01
    assert_equal 1, @pool.size
    assert_equal 1, @pool.num_idle
    refute @pool.workers.find{ |w| w.thread.alive? }

    foo = []
    @pool.perform do
      foo << "bar"
    end

    @pool.dispose

    @pool.summary
    assert_equal 1, foo.size
    assert_equal "bar", foo.first
  end

end # TestThreadPool
end # Test
end # Bixby
