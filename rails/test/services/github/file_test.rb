require 'test_helper'

class Github::FileTest < ActiveSupport::TestCase
  test 'get content' do
    payload = JSON.parse(file_fixture('github_file_contents.json').read)

    conn = OpenStruct.new
    conn.stubs(:contents).returns(payload)

    content = Github::File.new(conn).content('repo', 'filename')

    assert_equal(content, 'hello world')
  end
end
