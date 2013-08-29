
module Bixby
  module Debug

    # Simple helper for use in to_s methods
    def self.pretty_str(str) # :nocov:
      if str.nil? then
        "nil"
      elsif str.empty? then
        '""'
      elsif str.include? "\n" then
        "<<-EOF\n" + str + "\nEOF"
      else
        '"' + str + '"'
      end
    end # :nocov:

    # Pretty print a hash
    #
    # @example
    #   {
    #     content-md5   => "Rb0qo2Ae7KGcS5TDulOjYw==",
    #     date          => "Thu, 29 Aug 2013 13:49:53 GMT",
    #     authorization => "APIAuth c61ca57b8d7b3e95fba06a",
    #   }
    #
    # @param [Hash] hash
    # @return [String]
    def self.pretty_hash(hash)
      return "{}" if hash.empty?

      s = [ "\n\t{" ]
      l = hash.keys.max_by{ |k| k.length }.length + 1 # length of longest key so we can align values
      hash.keys.each{ |k| s << ("  %s%s=> %s," % [k, " "*(l-k.length), hash[k].inspect]) }
      s << "}"

      return s.join("\n\t")
    end

    def self.indent_lines(str, indent="\t")
      str.gsub(/\n/, "\n#{indent}")
    end

  end # Debug
end # Bixby
