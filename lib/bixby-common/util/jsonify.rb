
require 'multi_json'

module Bixby
module Jsonify

  include Hashify

  def to_json
    MultiJson.dump(self.to_hash)
  end

  module ClassMethods
    def from_json(json)
      json = MultiJson.load(json) if json.kind_of? String
      obj = self.allocate
      json.each{ |k,v| obj.send("#{k}=".to_sym, v) }
      obj
    end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end

end # Jsonify
end # Bixby
