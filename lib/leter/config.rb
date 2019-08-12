require 'dotenv/load'

module Leter
  class Config
    def self.css_dev_path
      ENV['CSS_DEV_PATH']
    end 

    def self.css_prod_path 
      ENV['CSS_PROD_PATH'] 
    end 

    def self.css_dev_url
      File.join(css_dev_path, Leter::CSS) 
    end 

    def self.css_prod_url 
      version = Leter::VERSION.gsub('.','_') 

      name = File.basename(Leter::CSS, ".css")

      css = "#{name}_#{version}.css" 

      File.join(css_prod_path, css)
    end
  end
end

