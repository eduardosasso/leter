# frozen_string_literal: true

module Leter
  class ImageSlider
    IMAGE_SLIDER_ASSETS = File.read(File.expand_path('_image_slider_assets.html.erb', __dir__))
    IMAGE_SLIDER_HTML = File.read(File.expand_path('_image_slider.html.erb', __dir__))

    def script
      asset = Leter::Asset.new(:glidejs)

      css = File.join(asset.path, 'css/glide.core.min.css')
      theme = File.join(asset.path, 'css/glide.theme.min.css')

      resources = {
        js: asset.url,
        css: css,
        theme: theme
      }

      ERB.new(IMAGE_SLIDER_ASSETS).result_with_hash(resources)
    end

    def html(images)
      ERB.new(IMAGE_SLIDER_HTML).result_with_hash(images: images)
    end
  end
end
