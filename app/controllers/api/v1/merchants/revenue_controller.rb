class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    revenue = Invoice.revenue_by_date(params[:date])
    render json: PriceSerializer.new({"total_revenue": revenue}).render
  end

  def show
    merchant_revenue = Merchant.find(params[:id]).revenue_by_date(params[:date])
    render json: PriceSerializer.new({"revenue": merchant_revenue}).render
  end
end
