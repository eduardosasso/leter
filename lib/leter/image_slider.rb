# frozen_string_literal: true

module Leter
  class ImageSlider
    IMAGE_SLIDER_PARTIAL = File.read(File.expand_path('_image_slider.html.erb', __dir__))

    def script
      asset = Leter::Asset.new(:glidejs)
      css = File.join(asset.path, 'css/glide.core.min.css')

      resources = {
        js: asset.url,
        css: css
      }

      ERB.new(IMAGE_SLIDER_PARTIAL).result_with_hash(resources)
    end
  end
end
