# frozen_string_literal: true

require 'net/http'
require 'colorize'
require 'json'
require 'leter/version'

module Leter
  class Asset
    attr_accessor :package, :version
    attr_reader :asset, :base_path

    CDN_BASE_PATH = 'https://cdn.jsdelivr.net/'

    # TODO: build system so to have leter.min.css and diff folder like dist
    GITHUB_PATH = [
      'gh/eduardosasso/leter@',
      Leter::VERSION,
      '/lib/leter/assets/'
    ].join('')

    API = 'https://data.jsdelivr.com/v1/package/'

    # TODO: support for leter.css and favicon urls from github until turns public
    ASSETS = {
      highlightjs: 'gh/highlightjs/cdn-release@9.17.1/build/highlight.min.js',
      normalize: 'npm/normalize.css@8.0.1/normalize.min.css',
      glidejs: 'npm/@glidejs/glide@3.4.1/dist/glide.min.js'
    }.freeze

    LOCAL_ASSETS = {
      css: GITHUB_PATH + 'leter.css',
      favicon: GITHUB_PATH + 'favicon.ico'
    }.freeze

    def initialize(name, base_path = CDN_BASE_PATH)
      @asset = ASSETS[name] || LOCAL_ASSETS[name]
      @base_path = base_path

      parse
    end

    def self.local(name)
      new(name)
    end

    def url
      File.join(base_path, asset)
    end

    def self.check
      ASSETS.keys.map do |lib|
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

    def path
      # path matches until last / before the filename
      File.join(base_path, asset.match(%r{.*/}).to_s)
    end

    def cdn_latest_version
      uri = URI(API + package)

      response = Net::HTTP.get(uri)

      JSON.parse(response)['versions'].first
    end

    private

    def parse
      @package = asset.match(/.+?(?=@\d)/).to_s # match up until @ followed by a number
      @version = asset.match(%r{(?<=@)\d.+?(?=/)}).to_s # match version after @ and before /
    end
  end
end
