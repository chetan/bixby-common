
class BaseModule

    class << self
        attr_accessor :agent, :manager_uri

        include HttpClient
    end

end