class GithubAppInstallJob < ApplicationJob
  queue_as :default

  def perform(payload)
    # TODO save installation in db 
  end
end
