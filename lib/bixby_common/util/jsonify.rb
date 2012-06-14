
require 'multi_json'

module Bixby
module Jsonify

  def to_json(options = nil)
    MultiJson.dump(self.to_json_properties.inject({}) { |h,k| h[k[1,k.length]] = self.instance_eval(k.to_s); h })
  end

  def to_json_properties
    self.instance_variables
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
