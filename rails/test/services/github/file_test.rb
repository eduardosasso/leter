require 'test_helper'

class Github::FileTest < ActiveSupport::TestCase
  test 'get content' do
    payload = JSON.parse(file_fixture('github_file_contents.json').read)

    conn = OpenStruct.new
    conn.stubs(:contents).returns(payload)

    content = Github::File.new(conn, 'repo').content('filename')

    assert_equal(content, 'hello world')
  end

  test 'delete' do
    #TODO, slow test vcr?
    req_payload = JSON.parse(file_fixture('github_push_delete_test_repo.json').read)
    payload = Github::Payload.new(req_payload)
    
    timestamp = Time.now

    conn = Github::Auth.new.client(payload.installation_id)

    item = Item.new
    item.filename = 'delete.html'
    item.data = "<h1>Hello World #{timestamp}</h1>"
    item.status = Item::STATUS[:updated]

    Github::Commit.new(conn, payload).push([item])

    response = Github::Commit.new(conn, payload).push([item])
    file = 'delete.html'
    commit_message = "delete test #{timestamp}"

    response = Github::File.new(conn, payload.repository_name).delete(file, commit_message)

    assert(response.commit.sha)
  end
end
