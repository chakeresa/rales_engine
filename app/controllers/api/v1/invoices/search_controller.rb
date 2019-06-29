class Api::V1::Invoices::SearchController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.search_all(search_params.to_h))
  end

  def show
    render json: InvoiceSerializer.new(Invoice.search(search_params.to_h))
  end

  private

  def search_params
    params.permit(:id, :customer_id, :merchant_id, :status, :created_at, :updated_at)
  end
end
