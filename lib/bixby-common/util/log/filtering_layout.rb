
module Bixby
  module Log

    class FilteringLayout < Logging::Layouts::Pattern

      # Filter the exception if a block is available
      #
      # @param [Exception] ex
      #
      # @return [Array<String>] backtrace
      def filter_ex(ex)
        if @filter.nil? then
          return ex.backtrace
        end

        return @filter.call(ex)
      end

      # Set the exception filter
      #
      # @param [Block] block
      # @yield [Exception] the exception to filter
      def set_filter(&block)
        @filter = block
      end

      # Return a string representation of the given object. Depending upon
      # the configuration of the logger system the format will be an +inspect+
      # based representation or a +yaml+ based representation.
      #
      # @param [Object] obj
      #
      # @return [String]
      def format_obj( obj )
        case obj
        when String; obj
        when Exception
          str = "<#{obj.class.name}> #{obj.message}"
          if @backtrace && !obj.backtrace.nil?
            str << "\n\t" << filter_ex(obj).join("\n\t")
          end
          str
        when nil; "<#{obj.class.name}> nil"
        else
          str = "<#{obj.class.name}> "
          str << case @obj_format
                 when :inspect; obj.inspect
                 when :yaml; try_yaml(obj)
                 when :json; try_json(obj)
                 else obj.to_s end
          str
        end
      end

    end

  end
end
