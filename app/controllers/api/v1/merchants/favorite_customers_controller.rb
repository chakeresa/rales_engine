class Api::V1::Merchants::FavoriteCustomersController < ApplicationController
  def show
    merchant = Merchant.find(params[:id])
    render json: CustomerSerializer.new(merchant.favorite_customers(1).first)
  end
end
