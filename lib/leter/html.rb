# frozen_string_literal: true

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
      parser.at_css('code').present?
    end

    def body
      parser.at_css('body').inner_html
    end

    def date
      parser.at_css('.published').try(:text)
    end

    def parser
      # @parser ||= Nokogiri::HTML.parse(html)
      Nokogiri::HTML.parse(html)
    end
  end
end
