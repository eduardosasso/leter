# frozen_string_literal: true

require 'net/http'
require 'colorize'
require 'json'

module Leter
  class Asset
    attr_accessor :package, :version
    attr_reader :library

    CDN_BASE_PATH = 'https://cdnjs.cloudflare.com/ajax/libs/'

    LIBRARIES = {
      highlightjs: 'highlight.js/9.15.10/highlight.min.js',
      normalize: 'normalize/8.0.1/normalize.min.css',
      hack_font: 'hack-font/3.003/web/hack.min.css'
    }.freeze

    def initialize(name)
      @library = LIBRARIES[name]

      parse
    end

    def url
      File.join(CDN_BASE_PATH, library)
    end

    def path
      File.join(CDN_BASE_PATH, package, version)
    end

    def self.check
      LIBRARIES.keys.map do |lib|
        asset = Asset.new(lib)

        status = asset.version == asset.cdn_latest_version ? :green : :red

        [
          lib,
          asset.version.colorize(status),
          '»',
          asset.cdn_latest_version.colorize(:green)
        ].join(' ')
      end.to_a.join("\n")
    end

    def cdn_latest_version
      uri = URI("https://api.cdnjs.com/libraries/#{package}?fields=version")

      response = Net::HTTP.get(uri)

      JSON.parse(response)['version']
    end

    private

    def parse
      @package, @version = library.split('/')
    end
  end
end
