class Api::V1::ItemsController < ApplicationController
  def index
    respond_with Item.page(params[:page]).per(params[:per_page])
  end

  private

  def page_params
    params.permt(:page, :page_size)
  end
end
