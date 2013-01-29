
module Bixby
  module Debug

    # Simply helper for use in to_s methods
    # :nocov:
    def self.pretty_str(str)
      if str.nil? then
        "nil"
      elsif str.empty? then
        '""'
      elsif str.include? "\n" then
        "<<-EOF\n" + str + "\nEOF"
      else
        '"' + str + '"'
      end
    end

  end # Debug
end # Bixby
