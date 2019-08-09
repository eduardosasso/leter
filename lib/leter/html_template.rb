module Leter
  class HtmlTemplate
    attr_accessor :title, :description, :body, :config

    # support templating of member data.
    def get_binding
      binding
    end
  end
end
