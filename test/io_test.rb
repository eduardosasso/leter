require 'test_helper'

class IOTest < Minitest::Test
  def test_list_files
    files = [
      'index.md',
      'resume.md',
      'tmp/blog/ruby.md',
      'tmp/blog/learning_go.md',
      'tmp/cooking/recipes/steak.md'
    ]

    files.each do |f|
      Leter::IO.save_file(f, 'test file')
    end

    assert_equal((Leter::IO.list_files & files).sort, files.sort)

    files.each do |f|
      Leter::IO.delete_file(f)
    end
  end

  def test_read_file
		file = 'hello.md'

		Leter::IO.save_file(file, 'hello world') 
    
    contents = Leter::IO.read_file(file)

    assert_equal('hello world', contents)
  end

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
