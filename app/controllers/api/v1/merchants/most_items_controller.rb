class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.top_x_by_items_sold_ct(params[:quantity]))
  end
end
