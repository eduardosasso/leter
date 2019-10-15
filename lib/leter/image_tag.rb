# frozen_string_literal: true

module Leter
  class ImageTag
    IMAGE_TAG = File.read(File.expand_path('_image.html.erb', __dir__))

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

    def html
      resources = {
        src: src,
        alt: alt,
        caption: alt
      }

      ERB.new(IMAGE_TAG).result_with_hash(resources)
    end
  end
end
