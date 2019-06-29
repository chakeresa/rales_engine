require 'rails_helper'

RSpec.describe Api::V1::Transactions::RandomController do
  describe "GET #show" do
    before(:each) do
      @t1, @t2, @t3 =  create_list(:transaction, 3)
      get "/api/v1/transactions/random"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a random transaction" do
      transaction_json = parse_api_1point0_response

      expect(transaction_json["attributes"]["invoice_id"]).to satisfy { |actual_invoice_id| [@t1.invoice_id, @t2.invoice_id, @t3.invoice_id].include?(actual_invoice_id) }
    end
  end
end
