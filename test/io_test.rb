require 'test_helper'

class IOTest < Minitest::Test
  def test_save_file
		file = 'hello.md'

		Leter::IO.save_file(file, 'hello world') 

		assert(File.file?(file))

		File.delete(file)
  end

  def test_save_file_and_create_folder
		file = 'tmp/test/site/index.md'

		Leter::IO.save_file(file, 'index') 

		assert(File.file?(file))

		File.delete(file)
  end
end
