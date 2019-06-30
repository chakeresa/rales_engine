class Api::V1::Customers::FavoriteMerchantsController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    render json: MerchantSerializer.new(customer.favorite_merchants(1).first)
  end
end
