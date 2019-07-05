module Leter
  class IndexTemplate
    attr_accessor :url, :items, :theme

    # support templating of member data.
    def get_binding
      binding
    end
  end
end
