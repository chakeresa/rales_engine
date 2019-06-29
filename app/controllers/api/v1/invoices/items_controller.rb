class Api::V1::Invoices::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Invoice.find(params[:invoice_id]).items)
  end
end
