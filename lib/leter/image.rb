# frozen_string_literal: true

module Leter
  class Image
    attr_accessor :ref, :src, :title, :alt
    attr_writer :single

    def single?
      @single
    end

    def previous_element
      ref.previous_element
    end

    def next_element
      ref.next_element
    end
  end
end
