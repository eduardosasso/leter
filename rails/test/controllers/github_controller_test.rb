require 'test_helper'

class GitubControllerTest < ActionDispatch::IntegrationTest
	def setup
    @payload = file_fixture('github_installation.json').read 

		@headers = {
			'Content-Type' => 'application/json',
      'X-GitHub-Event': 'installation',
      'X-Hub-Signature': 'sha1=3be3f0a9d065b23669e605b62c01b2a6da6d067e'
    }
  end

  test "event handler" do
    GithubController.any_instance.stubs(:verify_webhook_signature)

    post github_event_handler_path 

    assert_response :not_implemented
  end

  test "app installation" do
    post(github_event_handler_path, params: @payload, headers: @headers)
		
		assert_response :accepted
		assert(User.first)
  end
end
