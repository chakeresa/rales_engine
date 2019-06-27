class Api::V1::Merchants::SearchController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.search_all(search_params.to_h))
  end

  def show
    render json: MerchantSerializer.new(Merchant.search(search_params.to_h))
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
