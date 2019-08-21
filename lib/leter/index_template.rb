# frozen_string_literal: true

module Leter
  class IndexTemplate
    attr_accessor :root, :items

    # support templating of member data.
    def use_binding
      binding
    end
  end
end
