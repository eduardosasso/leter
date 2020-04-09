# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'leter/version'

Gem::Specification.new do |spec|
  spec.name = 'leter'
  spec.version = Leter::VERSION
  spec.authors = ['eduardosasso']
  spec.email = ['eduardo.sasso@gmail.com']

  spec.summary = ''
  spec.description = ''
  spec.homepage = 'https://leter.co'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "https://github.com/eduardosasso/leter"
  #   # spec.metadata["changelog_uri"] = ""
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = 'bin'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables = ['leter']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'aruba', '~> 1.0.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'colorize', '~> 0.8.1'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'csso-rails', '~> 0.8.1'
  spec.add_development_dependency 'dotenv', '~> 2.7', '>= 2.7.5'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1', '>= 1.1.11'
  spec.add_development_dependency 'rake', '~> 13.0'
  # TODO: add rubocop and auto run on test
  spec.add_development_dependency 'gem-release', '~> 2.1', '>= 2.1.1'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.3.0'

  spec.add_dependency 'activesupport', '~> 5.2', '>= 5.2.3'
  spec.add_dependency 'motion-markdown-it', '~> 8.4', '>= 8.4.1.1'
  spec.add_dependency 'motion-markdown-it-plugins', '~> 8.4', '>= 8.4.2.1'
  spec.add_dependency 'nokogiri', '~> 1.10', '>= 1.10.3'
end
