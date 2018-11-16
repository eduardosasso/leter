class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!

  def index
    # user_sites = current_user.sites
    # list sites
    # have button to add new site
  end
end
