class Api::V1::Merchants::SearchController < ApplicationController
  # def index
  #   render json: MerchantSerializer.new(Merchant.all)
  # end

  def show
    render json: MerchantSerializer.new(Merchant.where(search_params.to_h).first)
  end

  private

  def search_params
    if params["created_at"] && params["created_at"].class == String
      params["created_at"] = Time.zone.parse(params["created_at"])
    end
    if params["updated_at"] && params["updated_at"].class == String
      params["updated_at"] = Time.zone.parse(params["updated_at"])
    end
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
