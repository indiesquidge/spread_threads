class ItemsController < ApplicationController
  def index
    @items = Item.page(params[:page]).per(params[:per_page])
    respond_with @items
  end

  private

  def page_params
    params.require(:item).permt(:page, :per_page)
  end
end
