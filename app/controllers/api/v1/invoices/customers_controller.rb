class Api::V1::Invoices::CustomersController < ApplicationController
  def show
    render json: CustomerSerializer.new(Invoice.find(params[:invoice_id]).customer)
  end
end
