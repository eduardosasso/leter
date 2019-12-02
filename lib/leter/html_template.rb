# frozen_string_literal: true

module Leter
  class HtmlTemplate
    attr_accessor :title, :description, :body, :config, :has_code, :has_image_slider

    # support templating of member data.
    def use_binding
      binding
    end
  end
end
