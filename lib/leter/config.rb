module Leter
  class Config
    CSS_PROD_PATH = "https://s3-us-west-1.amazonaws.com/leter-themes/"

    def self.css_prod_url 
      version = Leter::VERSION.gsub('.','_') 

      name = File.basename(Leter::CSS, ".css")

      css = "#{name}_#{version}.css" 

      File.join(CSS_PROD_PATH, css)
    end
  end
end

