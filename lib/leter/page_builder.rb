# frozen_string_literal: true

require 'active_support/core_ext/object/try'
require 'nokogiri'
require 'erb'

require 'leter/html_template'
require 'leter/account_config'
require 'leter/markdown'
require 'leter/html'
require 'leter/code'
require 'leter/favicon'
require 'leter/image_slider'

module Leter
  class PageBuilder
    attr_accessor :config

    LAYOUT = File.read(File.expand_path('layout.html.erb', __dir__))

    def initialize(markdown, config = Leter::AccountConfig.default)
      @markdown = markdown
      @config = config
    end

    def html
      html_template = Leter::HtmlTemplate.new.tap do |h|
        h.title = title
        h.description = description
        h.config = config
        h.has_code = code?
        h.has_image_slider = image_slider?
      end

      # replaces img in html with tag or slider
      prepare_image_singles
      prepare_image_groups

      html_template.body = body

      # TODO: use result with hash can remove html_template file
      ERB.new(LAYOUT).result(html_template.use_binding)
    end

    def title
      config.title || html_helper.title
    end

    def description
      config.description || html_helper.description
    end

    # TODO
    # carousel options
    # https://github.com/metafizzy/flickity
    # https://github.com/glidejs/glide
    # popup options
    # https://github.com/biati-digital/glightbox
    # https://github.com/feimosi/baguetteBox.js
    # lazy loading
    # https://github.com/verlok/lazyload
    # TODO optimize images automatically
    def images; end

    def image?
      html_helper.image?
    end

    def image_slider?
      html_helper.image_group?
    end

    def code?
      html_helper.code?
    end

    def date
      html_helper.date
    end

    def add_date(date)
      if date
        published = "<span class='published'>#{date}</span>"

        html_helper.first_h1.try(:after, published)
      end

      self
    end

    def body
      html_helper.body
    end

    def prepare_image_singles
      html_helper.image_singles.each do |image|
        image.ref.replace(image.html)
      end
    end

    def prepare_image_groups
      html_helper.image_group.each do |group|
        images = group.collect(&:html)

        image_slider = ImageSlider.new.html(images)

        group.first.ref.replace(image_slider)

        group.drop(1).each do |image|
          image.ref.remove
        end
      end
    end

    def html_helper
      @html_helper ||= begin
        html = Leter::Markdown.new(@markdown).to_html
        Leter::Html.new(html)
      end
    end
  end
end
