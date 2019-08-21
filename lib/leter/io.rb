# frozen_string_literal: true

module Leter
  class IO
    def self.list_files(ext = 'md')
      Dir["**/*.#{ext}"]
    end

    def self.read_file(file)
      File.read(file)
    end

    def self.delete_file(file)
      File.delete(file) if File.exist?(file)

      dir = File.dirname(file)

      delete_all(dir) if Dir.empty?(dir)
    end

    def self.delete_all(*path)
      path.each { |p| FileUtils.remove_dir(p, force: true) }
    end

    def self.save_file(path, content)
      dir = File.dirname(path)

      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

      File.open(path, 'w+') { |file| file.write(content) }
    end
  end
end
