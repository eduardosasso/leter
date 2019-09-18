# frozen_string_literal: true

require 'active_support/inflector'

module Leter
  class Slug
    def initialize(name)
      @name = name
    end

    # translate stuff like my_blog_post.md to my-blog-post/index.html
    # for pretty urls
    def to_filename
      html_filename = index? ? '.html' : '/index.html'

      slug + html_filename
    end

    def to_url
      '/' + slug.gsub(/index$/, '')
    end

    def index?
      basename == 'index'
    end

    def to_s
      slug
    end

    private

    def slug
      [folder, basename.parameterize.dasherize].reject(&:empty?).join('')
    end

    def folder
      filename = File.basename(@name)
      @name.gsub(filename, '')
    end

    def basename
      File.basename(@name, '.*')
    end
  end
end
