module Leter
  class IO
    def list_files(ext='*.md')

    end

    def read_file(file)

    end

    def self.save_file(path, content)
      File.open(path, 'w+') { |file| file.write(content) }
    end
  end
end
