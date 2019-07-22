module Leter
  class HtmlParser
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
      html_parser.at_css('h1').try(:text)
    end

    def first_h2
      html_parser.at_css('h2').try(:text)
    end

    def first_paragraph
      html_parser.at_css('p').try(:text)
    end

    def powered_by
      html_parser.at('meta[name="generator"]')['content']
    end

    private

    def html_parser
      @html_parser ||= Nokogiri::HTML.parse(html)
    end
  end
end
