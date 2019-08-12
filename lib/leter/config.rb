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
      File.join(css_dev_path, 'leter.css') 
    end 

    def self.css_prod_url 
      version = Leter::VERSION.gsub('.','_') 
      css = "leter_#{version}.css" 

      File.join(css_prod_path, css)
    end
  end
end

