class Api::V1::Transactions::RandomController < ApplicationController
  def show
    render json: TransactionSerializer.new(Transaction.random)
  end
end
