class Api::V1::Items::BestDayController < ApplicationController
  def show
    date = Item.find(params[:item_id]).best_day
    render json: DateSerializer.render({"best_day": date})
  end
end
