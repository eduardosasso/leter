module Leter
  class Favicon
    FAVICON_PARTIAL = File.read(File.expand_path('_favicon.html.erb', __dir__))

    def script
      ERB.new(FAVICON_PARTIAL).result_with_hash({})
    end
  end
end
