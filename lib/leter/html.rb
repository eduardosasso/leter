# frozen_string_literal: true

require 'leter/image_tag'

module Leter
  class Html
    attr_reader :html

    def initialize(html)
      @html = html
    end

    def title
      first_h1.try(:text) || first_h2.try(:text)
    end

    def description
      first_h2.try(:text) || first_paragraph.try(:text)
    end

    def first_h1
      parser.at_css('h1')
    end

    def first_h2
      parser.at_css('h2')
    end

    def first_paragraph
      parser.at_css('p')
    end

    def powered_by
      (parser.at('meta[name="generator"]') || {})['content']
    end

    def code?
      parser.at_css('code')
    end

    def image?
      images.any?
    end

    def images
      parser.css('img').map do |img|
        single = [
          img.previous_element.try(:name) != 'img',
          img.next_element.try(:name) != 'img'
        ].all?

        ImageTag.new.tap do |i|
          i.ref = img
          i.src = img.attr(:src)
          i.title = img.attr(:title)
          i.alt = img.attr(:alt)
          i.single = single
        end
      end
    end

    def image_singles
      images.select(&:single?)
    end

    def image_group
      group = []
      chain = Set.new

      images.each do |image|
        img_before = image.previous_element.try(:name) == 'img'
        img_after = image.next_element.try(:name) == 'img'

        chain.add(image) if img_before || img_after

        if img_before && !img_after
          group.push(chain.dup)
          chain.clear
        end
      end

      group
    end

    def image_group?
      image_group.any?
    end

    def body
      parser.at_css('body').inner_html
    end

    def theme_name
      parser.at('body')['id']
    end

    def date
      parser.at_css('.published').try(:text)
    end

    def parser
      @parser ||= Nokogiri::HTML.parse(html)
    end
  end
end
