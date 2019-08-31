# frozen_string_literal: true

require 'leter/asset'
# TODO write tests
module Leter
  class Code
    CODE_PARTIAL = File.read(File.expand_path('_code.html.erb', __dir__))

    def initialize(account_config)
      @config = account_config
    end

    def add
      asset = Leter::Asset.new(:highlightjs)
      css = File.join(asset.path, 'styles', @config.code_theme, '.min.css')

      resources = {
        js: asset.url,
        css: css
      }

      ERB.new(CODE_PARTIAL).result_with_hash(resources)
    end
  end
end
