require 'optparse'

module Leter
  class Cli
    def start
      OptionParser.new do |parser|
        #TODO add description in banner
        parser.banner = "Usage: leter [options]"

        parser.on('-n', '--new', 'Setup leter.yml file') do
          config = Leter::AccountConfig

          warning('leter.yml already exists') && exit if File.file?(config.filename)

          Leter::IO.save_file(config.filename, config.default.to_yaml)

          info('✔ leter.yml created!')
        end

        parser.on('-b', '--build', 'Convert all markdown files to HTML') do |name|
          #TODO alert configuration not found, or run leter -n
          options[:name] = name
        end

        parser.on("-h", "--help", "Show this help message") do ||
          puts parser
        end

        parser.on("-v", "--version", "Show Leter version") do ||
          puts Leter::VERSION
        end

        parser.on("-c", "--clean", "Clean") do ||
          puts Leter::VERSION
        end

      end.parse!
    end

    def info(message)
      puts message
    end

    def warning(message)
      puts message
    end
  end
end
