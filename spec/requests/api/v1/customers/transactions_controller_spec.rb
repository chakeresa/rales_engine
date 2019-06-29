require 'rails_helper'

RSpec.describe Api::V1::Customers::TransactionsController do
  describe "GET #index" do
    before(:each) do
      @customer = create(:customer)
      @i1, @i2 = create_list(:invoice, 2, customer: @customer)
      @t1 = create(:transaction, invoice: @i1)
      @t2 = create(:transaction, invoice: @i2)
      @t3 = create(:transaction, invoice: @i2, result: "failed")
      create_list(:customer, 3)

      get "/api/v1/customers/#{@customer.id}/transactions"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all transactions for a particular customer" do
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(3)

      expected_first =  {
        "id" => @t1.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => @t1.id,
          "invoice_id" => @t1.invoice_id,
          "credit_card_number" => @t1.credit_card_number,
          "result" => @t1.result
        }
      }
      expect(transactions.first).to eq(expected_first)
    end
  end
end
