class GithubController < ActionController::Base
  include GithubHelper

  before_action :authenticate!, only: :event_handler

  def authenticate!
    @payload, @payload_raw = parse_payload

    verify_webhook_signature(@payload_raw)

    GithubService.new.tap do |g|
      g.authenticate_app

      # authenticate app installation make api calls
      g.authenticate_installation(@payload['installation']['id'])
    end
  end

  # webhook that listen for all events coming
  # from the github app
  def event_handler
		#TODO should never block this thread
    #sidekiq active job to process

		event = request.headers['X-GitHub-Event']
		status = :accepted

		case event 
		when 'installation'
      GithubAppInstallJob.perform_later(payload)
		else
			status = :not_implemented
		end
		
		head status
  end
end
