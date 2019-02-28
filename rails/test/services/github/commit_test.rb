require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  test 'push single file' do
    req_payload = JSON.parse(file_fixture('github_push_update_test_repo.json').read)
    payload = Github::Payload.new(req_payload)
    
    timestamp = Time.now

    payload.stubs(:commit_message).returns("Test #{timestamp}")

    conn = Github::Auth.new.client(payload.installation_id)

    item = Item.new
    item.filename = 'resume/index.html'
    item.html = "<h1>Hello World #{timestamp}</h1>"
    item.status = Item::STATUS[:updated]

    response = Github::Commit.new(conn, payload).push([item])

    assert(response.object.sha)
  end
end
