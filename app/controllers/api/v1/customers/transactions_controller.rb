class Api::V1::Customers::TransactionsController < ApplicationController
  def index
    render json: TransactionSerializer.new(Customer.find(params[:customer_id]).transactions)
  end
end
