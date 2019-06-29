class Api::V1::Customers::SearchController < ApplicationController
  def index
    render json: CustomerSerializer.new(Customer.search_all(search_params.to_h))
  end

  def show
    render json: CustomerSerializer.new(Customer.search(search_params.to_h))
  end

  private

  def search_params
    params.permit(:id, :first_name, :last_name, :created_at, :updated_at)
  end
end
