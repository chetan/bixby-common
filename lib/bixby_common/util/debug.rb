
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

  end # Debug
end # Bixby
