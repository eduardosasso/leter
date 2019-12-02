# frozen_string_literal: true

require 'leter/asset'

module Leter
  class Code
    CODE_PARTIAL = File.read(File.expand_path('_code.html.erb', __dir__))

    def initialize(account_config)
      @config = account_config
    end

    def script
      asset = Leter::Asset.new(:highlightjs)

      filename = @config.code_theme + '.min.css'
      css = File.join(asset.path, 'styles', filename)

      font = Leter::Asset.new(:hack_font).url

      resources = {
        js: asset.url,
        css: css,
        font: font
      }

      ERB.new(CODE_PARTIAL).result_with_hash(resources)
    end
  end
end
