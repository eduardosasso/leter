# frozen_string_literal: true

# require 'mini_magick'
# NOT IMPLEMENTED
module Leter
  # TODO: check if imagemagick is installed
  class Image
    attr_reader :url

    ORIGINAL = 0
    DISPLAY = 700
    LARGE = 1024

    SIZES = [DISPLAY, LARGE].freeze

    def initialize(url)
      @url = url
    end

    def resize
      SIZES.each do |size|
        resized_image_path = resize_name(size)

        image_magick.tap do |img|
          img.resize("#{size}x#{size}")
          img.write(resized_image_path)
        end
      end
    end

    def display_url
      resize_name(DISPLAY)
    end

    def large_url
      resize_name(LARGE)
    end

    def original_url; end

    def size(format = nil); end

    def dimensions(format = nil); end

    def width(format = nil); end

    def height(format = nil); end

    def path
      File.dirname(url)
    end

    def filename
      File.basename(url, '.*')
    end

    def extension
      File.extname(url)
    end

    def original?
      [
        url =~ /#{suffix(DISPLAY)}/,
        url =~ /#{suffix(LARGE)}/
      ].compact.empty?
    end

    def suffix(size)
      '_L' + size.to_s
    end

    def resize_name(size)
      [
        path,
        '/',
        filename,
        suffix(size),
        extension
      ].join('')
    end

    # TODO: test local and remove images
    # url should translate to local url
    def image_magick
      @image_magick ||= MiniMagick::Image.open(url)
    end
  end
end
