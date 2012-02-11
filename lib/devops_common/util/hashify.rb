
module Hashify
  def to_hash
    self.instance_variables.inject({}) { |m,v| m[v[1,v.length].to_sym] = instance_variable_get(v); m }
  end
end
