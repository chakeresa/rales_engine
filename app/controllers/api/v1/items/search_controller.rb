class Api::V1::Items::SearchController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.search_all(search_params.to_h))
  end

  def show
    render json: ItemSerializer.new(Item.search(search_params.to_h))
  end

  private

  def search_params
    if params[:unit_price]
      params[:unit_price] = dollars_to_cents(params[:unit_price])
    end
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
