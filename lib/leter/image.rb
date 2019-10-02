# frozen_string_literal: true

module Leter
  class Image
    def initialize(path)
      @path = path
    end

    def local?
      # TODO: local or remote image
    end

    def size; end

    def orientation; end

    def to_html; end
  end
end
