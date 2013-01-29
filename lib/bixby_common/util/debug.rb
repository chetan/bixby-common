
module Bixby
  module Debug

    def self.pretty_str(str)
      if str.nil? then
        "nil"
      elsif str.empty? then
        "''"
      else
        "<<-EOF\n" + str + "\nEOF"
      end
    end

  end # Debug
end # Bixby
