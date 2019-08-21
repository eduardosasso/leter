# frozen_string_literal: true

module Leter
  class HtmlTemplate
    attr_accessor :title, :description, :body, :config

    # support templating of member data.
    def use_binding
      binding
    end
  end
end
