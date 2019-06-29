require 'rails_helper'

RSpec.describe Api::V1::Transactions::SearchController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @invoice_id = create(:invoice).id
      @credit_card_number = "50000000000"
      @result = "failed"
      @created_at = "2012-03-27 14:53:59 UTC"
      @updated_at = "2013-03-27 14:53:59 UTC"
      @first_transaction, @sec_transaction = create_list(:transaction, 2, invoice_id: @invoice_id, credit_card_number: @credit_card_number, result: @result, created_at: @created_at, updated_at: @updated_at)
      create_list(:transaction, @count - 2)
    end

    it "returns http success" do
      get "/api/v1/transactions/find_all?invoice_id=#{@invoice_id}"
      expect(response.status).to eq(200)
    end

    it "outputs data for all transactions with a particular invoice_id" do
      get "/api/v1/transactions/find_all?invoice_id=#{@invoice_id}"
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(2)

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

    it "outputs data for all transactions with a particular credit_card_number" do
      get "/api/v1/transactions/find_all?credit_card_number=#{@credit_card_number}"
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(2)

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

    it "outputs data for all transactions with a particular result" do
      get "/api/v1/transactions/find_all?result=#{@result}"
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(2)

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

    it "outputs data for all transactions with a particular created_at" do
      get "/api/v1/transactions/find_all?created_at=#{@created_at}"
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(2)

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

    it "outputs data for all transactions with a particular updated_at" do
      get "/api/v1/transactions/find_all?updated_at=#{@updated_at}"
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(2)

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
      @count = 3
      @first_transaction = create(:transaction, credit_card_number: "50000000000", result: "failed", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2013-03-27 14:53:59 UTC")
      @other_transactions =  create_list(:transaction, @count - 1, created_at: "2014-03-27 14:53:59 UTC", updated_at: "2015-03-27 14:53:59 UTC")
    end

    it "returns http success" do
      get "/api/v1/transactions/find?id=#{@first_transaction.id}"
      expect(response.status).to eq(200)
    end

    it "finds an transaction by id" do
      transaction_resource = @other_transactions.first
      get "/api/v1/transactions/find?id=#{transaction_resource.id}"
      transaction_json = parse_api_1point0_response

      expected_hash =  {
        "id" => transaction_resource.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => transaction_resource.id,
          "invoice_id" => transaction_resource.invoice_id,
          "credit_card_number" => transaction_resource.credit_card_number,
          "result" => transaction_resource.result
        }
      }
      expect(transaction_json).to eq(expected_hash)
    end

    it "finds an transaction by invoice_id" do
      transaction_resource = @other_transactions.first
      get "/api/v1/transactions/find?invoice_id=#{transaction_resource.invoice_id}"
      transaction_json = parse_api_1point0_response

      expected_hash =  {
        "id" => transaction_resource.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => transaction_resource.id,
          "invoice_id" => transaction_resource.invoice_id,
          "credit_card_number" => transaction_resource.credit_card_number,
          "result" => transaction_resource.result
        }
      }
      expect(transaction_json).to eq(expected_hash)
    end

    it "finds an transaction by credit_card_number" do
      transaction_resource = @other_transactions.first
      get "/api/v1/transactions/find?credit_card_number=#{transaction_resource.credit_card_number}"
      transaction_json = parse_api_1point0_response

      expected_hash =  {
        "id" => transaction_resource.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => transaction_resource.id,
          "invoice_id" => transaction_resource.invoice_id,
          "credit_card_number" => transaction_resource.credit_card_number,
          "result" => transaction_resource.result
        }
      }
      expect(transaction_json).to eq(expected_hash)
    end

    it "finds an transaction by result" do
      transaction_resource = @other_transactions.first
      get "/api/v1/transactions/find?result=#{transaction_resource.result}"
      transaction_json = parse_api_1point0_response

      expected_hash =  {
        "id" => transaction_resource.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => transaction_resource.id,
          "invoice_id" => transaction_resource.invoice_id,
          "credit_card_number" => transaction_resource.credit_card_number,
          "result" => transaction_resource.result
        }
      }
      expect(transaction_json).to eq(expected_hash)
    end

    it "finds an transaction by created_at" do
      transaction_resource = @other_transactions.first
      get "/api/v1/transactions/find?created_at=#{transaction_resource.created_at}"
      transaction_json = parse_api_1point0_response

      expected_hash =  {
        "id" => transaction_resource.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => transaction_resource.id,
          "invoice_id" => transaction_resource.invoice_id,
          "credit_card_number" => transaction_resource.credit_card_number,
          "result" => transaction_resource.result
        }
      }
      expect(transaction_json).to eq(expected_hash)
    end

    it "finds an transaction by updated_at" do
      transaction_resource = @other_transactions.first
      get "/api/v1/transactions/find?updated_at=#{transaction_resource.updated_at}"
      transaction_json = parse_api_1point0_response

      expected_hash =  {
        "id" => transaction_resource.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => transaction_resource.id,
          "invoice_id" => transaction_resource.invoice_id,
          "credit_card_number" => transaction_resource.credit_card_number,
          "result" => transaction_resource.result
        }
      }
      expect(transaction_json).to eq(expected_hash)
    end
  end
end
