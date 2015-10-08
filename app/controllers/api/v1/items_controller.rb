class Api::V1::ItemsController < ApplicationController
  def index
    respond_with Item.all
  end
end
