class Api::V1::Transactions::SearchController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.search_all(search_params.to_h))
  end

  def show
    render json: TransactionSerializer.new(Transaction.search(search_params.to_h))
  end

  private

  def search_params
    params.permit(:id, :invoice_id, :credit_card_number, :result, :created_at, :updated_at)
  end
end
