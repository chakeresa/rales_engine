class Api::V1::Merchants::CustomersWithPendingInvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    render json: CustomerSerializer.new(merchant.customers_with_pending_invoices)
  end
end
