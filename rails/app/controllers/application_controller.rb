class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!

  def index
    @primary_site = current_user.default_site

    # user_sites = current_user.sites
    # list sites
    # have button to add new site
  end
end
