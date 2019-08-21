# frozen_string_literal: true

module Leter
  class Html
    attr_reader :html

    def initialize(html)
      @html = html
    end

    def title
      first_h1 || first_h2
    end

    def description
      first_h2 || first_paragraph
    end

    def first_h1
      parser.at_css('h1').try(:text)
    end

    def first_h2
      parser.at_css('h2').try(:text)
    end

    def first_paragraph
      parser.at_css('p').try(:text)
    end

    def powered_by
      (parser.at('meta[name="generator"]') || {})['content']
    end

    def parser
      @parser ||= Nokogiri::HTML.parse(html)
    end
  end
end
