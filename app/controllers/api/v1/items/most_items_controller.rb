class Api::V1::Items::MostItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.top_x_by_items_sold_ct(params[:quantity]))
  end
end
