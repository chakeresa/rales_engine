require 'rails_helper'

RSpec.describe Api::V1::TransactionsController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_transaction = create(:transaction)
      create_list(:transaction, @count - 1)
      get '/api/v1/transactions'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all transactions" do
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(@count)

      expected_first =  {
        "id" => @first_transaction.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => @first_transaction.id,
          "invoice_id" => @first_transaction.invoice_id,
          "credit_card_number" => @first_transaction.credit_card_number,
          "result" => @first_transaction.result
        }
      }
      expect(transactions.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_transaction = create(:transaction)
      @other_transactions =  create_list(:transaction, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/transactions/#{@first_transaction.id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a single transaction" do
      get "/api/v1/transactions/#{@first_transaction.id}"
      transaction = parse_api_1point0_response

      expect(transaction.class).to eq(Hash)

      expected_hash =  {
        "id" => @first_transaction.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => @first_transaction.id,
          "invoice_id" => @first_transaction.invoice_id,
          "credit_card_number" => @first_transaction.credit_card_number,
          "result" => @first_transaction.result
        }
      }
      expect(transaction).to eq(expected_hash)
    end
  end
end
