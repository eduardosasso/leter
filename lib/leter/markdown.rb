# frozen_string_literal: true

require 'motion-markdown-it'
require 'motion-markdown-it-plugins'

module Leter
  class Markdown
    def initialize(text)
      @text = text
    end

    def to_html
      MarkdownIt::Parser.new(
        linkify: true,
        typographer: true
      ).tap do |m|
        m.use(MotionMarkdownItPlugins::Emoji)
        m.use(MotionMarkdownItPlugins::Sub)
        m.use(MotionMarkdownItPlugins::Sup)
        m.use(MotionMarkdownItPlugins::Abbr)
        m.use(MotionMarkdownItPlugins::Mark)
      end.render(@text)
    end

    def self.is?(filename)
      File.extname(filename).in?(['.md', '.markdown'])
    end
  end
end
