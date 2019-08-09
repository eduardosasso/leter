require 'optparse'
require 'whirly'

module Leter
  class Cli
    attr_reader :status

    def start
      OptionParser.new do |parser|
        #TODO add description in banner
        parser.banner = "Usage: leter [options]"

        parser.on('-n', '--new', 'Setup leter.yml file') do
         setup
        end

        parser.on('-b', '--build', 'Build website') do
          build
        end

        parser.on('-x', '--css', 'Debug CSS') do
          # TODO add leter.css to root
        end

        parser.on("-c", "--clean", "Clean") do 
          clean
        end

        parser.on("-h", "--help", "Show this help message") do
          info(parser)

          hidden_switch = "--css"

          message = parser.to_s.split("\n").delete_if { |line| line =~ /#{hidden_switch}/ }.join("\n") 

          info(message)
        end

        parser.on("-v", "--version", "Show Leter version") do
          info(Leter::VERSION)
        end
      end.parse!
    end

    def setup
      config = Leter::AccountConfig

      warning('leter.yml already exists') && exit if File.file?(config.filename)

      Leter::IO.save_file(config.filename, config.default.to_yaml)

      info('✔ leter.yml created!')
    end

    def build
      spinner.start

      website.try(:build)

      spinner.stop
    end

    def clean
      spinner.start

      website.try(:clean)

      spinner.stop

    end

    def info(message)
      puts message
    end

    def warning(message)
      puts message
    end

    # callback for observer
    def update(status)
      #for testing only
      info(status) unless $stdout.tty?

      spinner.status = status
    end

    private

    def website
      Leter::Website.new(load_config).tap do |w|
        w.add_observer(self)
      end
    rescue Leter::NoConfigError
      warning('leter.yml not found!') 
    end

    def spinner
      @spinner ||= Whirly.tap do |w|
        w.configure(spinner: 'bouncingBar')
      end
    end

    def load_config
      path = Leter::AccountConfig.filename

      Leter::AccountConfig.load(path)
    end
  end
end
