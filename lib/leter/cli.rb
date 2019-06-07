require 'optparse'

module Leter
  class Cli
    def start
      OptionParser.new do |parser|
        #TODO add description in banner
        parser.banner = "Usage: leter [options]"

        parser.on('-n', '--new', 'Setup leter.yml file') do |name|
          options[:name] = name
        end

        parser.on('-f', '--file NAME ...', 'Convert individual markdown files to HTML') do |name|
          #TODO check for leter.yml in home folder, throw error suggest running leter --new
          options[:name] = name
        end

        parser.on('-a', '--all', 'Convert all markdown files to HTML') do |name|
          options[:name] = name
        end

        parser.on("-h", "--help", "Show this help message") do ||
          puts parser
        end

        parser.on("-v", "--version", "Show Leter version") do ||
          puts Leter::VERSION
        end

      end.parse!
    end
  end
end
