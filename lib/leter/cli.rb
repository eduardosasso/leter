# frozen_string_literal: true

require 'optparse'
require 'colorize'

require 'leter/io'
require 'leter/account_config'
require 'leter/website'
require 'leter/theme'

module Leter
  class Cli
    attr_reader :status

    def start # rubocop:disable  Metrics/MethodLength
      OptionParser.new do |parser|
        # TODO: add description in banner
        parser.banner = 'Usage: leter [options]'

        parser.on('-n', '--new', 'Setup leter.yml file') do
          setup
        end

        parser.on('-b', '--build [name]', 'Compile your website') do |name|
          build(name)
        end

        parser.on('-c', '--clean', 'Reset to clean slate') do
          clean
        end

        parser.on('-t', '--themes', 'List available themes') do
          themes
        end

        parser.on('-h', '--help', 'Displays this message') do
          puts parser
        end

        parser.on('-v', '--version', 'Current version number') do
          puts Leter::VERSION
        end
      end.parse!
    end

    def setup
      config = Leter::AccountConfig

      if File.file?(config.filename)
        info('leter.yml already exists!', :yellow)
        exit
      end

      Leter::IO.save_file(config.filename, config.default_config)

      info('leter.yml created!', :blue)
    end

    def build(name=nil)
      @color = :green

      website.try(:build, name)

      puts # empty line
      puts('⚡ Done!')
    end

    def clean
      @color = :red

      website.try(:clean)

      puts # empty line
      puts('⚡ Cleaned!')
    end

    def themes
      puts Theme.print
    end

    def info(message, color = :white)
      puts ' ● '.colorize(color) + message
    end

    def warning(message)
      info(message.colorize(:red))
    end

    # callback for observer
    def update(status)
      info(status, @color)
    end

    private

    def website
      Leter::Website.new(load_config).tap do |w|
        w.add_observer(self)
      end
    rescue Leter::NoConfigError
      info('leter.yml not found!', :red)

      exit
    end

    def load_config
      path = Leter::AccountConfig.filename

      Leter::AccountConfig.load(path)
    end
  end
end
