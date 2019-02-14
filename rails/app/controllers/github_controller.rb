class GithubController < ActionController::Base
  include GithubHelper

  before_action :verify_is_user
  before_action :verify_webhook_signature, only: :event_handler

  #TODO, should log all interactions
  #TODO, should validate account if paid or not rules
  #TODO, only trigger if changes on master 
  #webhook that listen for all events coming
  #from the github app
  def event_handler
    event = request.headers['X-GitHub-Event']
    status = :accepted

    app = Github::App.new(payload)

    case event
    when 'installation'
      app.install
    when 'push'
      app.build_async
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
