
require 'helper'

module Bixby
module Test

class TestLog < TestCase

  def test_setup_logger
    ENV["BIXBY_LOG"] = "DEBUG"
    Bixby::Log.setup_logger
    assert_equal 0, Logging::Logger.root.level # debug

    ENV["BIXBY_LOG"] = "error"
    Bixby::Log.setup_logger
    assert_equal 3, Logging::Logger.root.level # debug

    ENV.delete("BIXBY_LOG")
    Bixby::Log.setup_logger
    assert_equal 1, Logging::Logger.root.level # info

    Bixby::Log.setup_logger(:level => :error)
    assert_equal 3, Logging::Logger.root.level # error
  end

  def test_filtering_layout

    filter = Bixby::Log::FilteringLayout.new

    f = "foo"
    assert_equal "foo", filter.format_obj(f)
    assert filter.format_obj(nil) =~ /NilClass/
    assert filter.format_obj(3) =~ /Fixnum.*3/

    begin
      raise "foo"
    rescue => ex
      assert filter.format_obj(ex) =~ /micron/

      # filter out all turn lines
      filter.set_filter do |ex|
        ex.backtrace.reject{ |s| s =~ /micron/ }
      end
      refute filter.format_obj(ex) =~ /micron/

    end
  end

  def test_console?
    Logging::Logger.root.clear_appenders
    refute Bixby::Log.console?(Logging::Logger.root)
  end

  def test_cleanup_ex
    ex = nil
    begin
      raise "foobar had a problem"
    rescue Exception => ex
    end

    assert ex

    Logging::Logger.root.clear_appenders
    assert_kind_of Exception, Bixby::Log.clean_ex_for_console(ex, Logging::Logger.root)

    str = Bixby::Log.clean_ex(ex)
    assert str
    assert_kind_of String, str

    assert str.split(/\n/).first =~ /foobar had a problem/
    refute str.include? "/gems/"
  end

end # TestLog

end # Test
end # Bixby
