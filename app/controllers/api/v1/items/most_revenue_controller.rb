class Api::V1::Items::MostRevenueController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.top_x_by_revenue(params[:quantity]))
  end
end
