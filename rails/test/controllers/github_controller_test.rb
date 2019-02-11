require 'test_helper'

class GitubControllerTest < ActionDispatch::IntegrationTest
  test "event handler" do
		skip('for now')
    GithubController.any_instance.stubs(:authenticate!).returns(nil)

    post github_event_handler_path 

    assert_response :success
  end

  test "app installation" do
    GithubController.any_instance.stubs(:authenticate!).returns(nil)

    payload = file_fixture('github_installation.json').read 
		header = {'X-GitHub-Event': 'installation'}

    post(github_event_handler_path, params: payload, headers: header, as: :json)
		
		assert_response :accepted
  end
end
