module Leter
  class IndexTemplate
    attr_accessor :items

    # support templating of member data.
    def get_binding
      binding
    end
  end
end
