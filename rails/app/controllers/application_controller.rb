class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  def index
    render plain:'testsddx'
  end
end
