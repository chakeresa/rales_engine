class Api::V1::TransactionsController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.all)
  end

  def show
    render json: TransactionSerializer.new(Transaction.find(params[:id]))
  end
end
