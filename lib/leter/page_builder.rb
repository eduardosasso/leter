# frozen_string_literal: true

require 'active_support/core_ext/object/try'
require 'nokogiri'
require 'erb'

require 'leter/html_template'
require 'leter/account_config'
require 'leter/markdown'
require 'leter/html'
require 'leter/code'

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
        h.body = body
        h.config = config
        h.has_code = code?
      end

      # TODO: use result with hash can remove html_template file
      ERB.new(LAYOUT).result(html_template.use_binding)
    end

    def title
      html_helper.title
    end

    def description
      html_helper.description
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

    def html_helper
      @html_helper ||= begin
        html = Leter::Markdown.new(@markdown).to_html
        Leter::Html.new(html)
      end
    end
  end
end
