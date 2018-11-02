class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def index
    render plain:'testsddx'
  end
end
