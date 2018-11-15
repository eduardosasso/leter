class SitesController < ApplicationController
  def index
    render plain: 'index'
  end

  def new
    render plain: 'new'
    # show new form then after save redirect to index or to root
  end
end
