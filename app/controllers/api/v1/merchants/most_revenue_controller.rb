class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.top_x_by_revenue(params[:quantity]))
  end
end
