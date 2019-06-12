module Leter
  class IO
    def list_files(ext='*.md')

    end

    def read_file(file)

    end

    def self.save_file(path, content)
      dir = File.dirname(path)

      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

      File.open(path, 'w+') { |file| file.write(content) }
    end
  end
end
