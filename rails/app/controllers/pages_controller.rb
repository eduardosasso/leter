class PagesController < ApplicationController
  def create
    @page = Page.new(allowed_params).tap do |p|
      p.site = current_user.default_site
    end

    if @page.save!
      flash[:notice] = 'New page created'

      redirect_to edit_page_path(@page)
    end
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.where(site: current_user.default_site, id: params[:id]).first
  end

  def update
    Page.where(site: current_user.default_site, id: params[:id]).first.tap do |p|
      p.update_attributes(allowed_params)

      redirect_to edit_page_path(p)
    end
  end

  private

  def allowed_params
    params.require(:page).permit(:title, :content, :home, :type)
  end
end
