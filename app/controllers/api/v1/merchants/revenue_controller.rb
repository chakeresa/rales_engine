class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    revenue = Invoice.revenue_by_date(params[:date])
    render json: PriceSerializer.render({"total_revenue": revenue})
  end

  def show
    merchant_revenue = Merchant.find(params[:id]).revenue_by_date(params[:date])
    render json: PriceSerializer.render({"revenue": merchant_revenue})
  end
end
