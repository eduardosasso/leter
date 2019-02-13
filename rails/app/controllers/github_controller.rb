class GithubController < ActionController::Base
  include GithubHelper

  before_action :verify_webhook_signature, only: :event_handler

  # webhook that listen for all events coming
  # from the github app
  def event_handler
    #TODO should never block this thread
    #sidekiq active job to process
    event = request.headers['X-GitHub-Event']
    status = :accepted

    case event
    when 'installation'
      Github::App.new(payload).install
    else
      status = :not_implemented
    end

    head status
  end

  # callback for new install
  def install_setup
    #TODO redirect to page so user can configure settings
  end
end
