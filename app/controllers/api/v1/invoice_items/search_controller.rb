class Api::V1::InvoiceItems::SearchController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.search_all(search_params.to_h))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.search(search_params.to_h))
  end

  private

  def search_params
    if params[:unit_price]
      params[:unit_price] = dollars_to_cents(params[:unit_price])
    end
    params.permit(:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end
