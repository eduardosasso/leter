module Leter
  class Website
    attr_reader :config

    def initialize(config = Leter::AccountConfig.default)
      @config = config
    end

    def build
      #
      # create assets folder and copy all assets
      # generate html with correct slug/folder name structure for every markdown file
      # generate index for every folder with html files? - for every page being built keep a track of name and url
      # and use that to power the index
      # same can apply for sitemap and rss
      
      #TODO should read config from system

      io = Leter::IO

      io.list_files.each do |file|
        markdown = io.read_file(file)

        html = Leter::PageBuilder.new(markdown, config).html

        path_and_file = Leter::Slug.new(file).to_s

        io.save_file(path_and_file, html) 
      end
    end

    def clean
      # list all *.md files and get their html names and remove all
      # delete leter assets folder
      # list all index.hrml files and check if it was generated by leter then delete
      # delete all empty folders
    end
  end

  private

  def assets_folder
		Dir.mkdir('assets') unless Dir.exist?('assets')
  end
end
