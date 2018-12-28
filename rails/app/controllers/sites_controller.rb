class SitesController < ApplicationController
  def index
    @sites = Site.where(account: current_user.account)
  end

  def create
    # TODO, show option to select if user > 1 account
    @site = Site.new(allowed_params).tap do |s|
      s.account = current_user.account
    end

    # if @site.save!
    #   flash[:notice] = 'Successfully created project.'

    #   redirect_to sites_path
    # else
      # render :new
      redirect_to :back
    # end
  end

  def new
    @site = Site.new
  end
  
  def destroy
    Site.where(account: current_user.account, id: params[:id]).delete_all
    redirect_to sites_path
  end

  private

  def allowed_params
    params.require(:site).permit(:domain, :subdomain, :account)
  end
end
