class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: RevenueSerializer.new(Invoice.revenue_by_date(params[:date])).render
  end
end
