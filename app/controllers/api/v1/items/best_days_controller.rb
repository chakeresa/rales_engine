class Api::V1::Items::BestDaysController < ApplicationController
  def show
    date = Item.find(params[:item_id]).best_days(1).first.date
    render json: DateSerializer.render({"best_day": date})
  end
end
