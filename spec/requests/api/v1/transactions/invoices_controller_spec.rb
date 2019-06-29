require 'rails_helper'

RSpec.describe Api::V1::Transactions::InvoicesController do
  describe "GET #show" do
    before(:each) do
      @invoice = create(:invoice)
      @other_invoice = create(:invoice)
      @transaction = create(:transaction, invoice: @invoice)

      get "/api/v1/transactions/#{@transaction.id}/invoice"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a particular transaction's invoice" do
      actual = parse_api_1point0_response

      expected =  {
        "id" => @invoice.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => @invoice.id,
          "customer_id" => @invoice.customer_id,
          "merchant_id" => @invoice.merchant_id,
          "status" => @invoice.status
        }
      }
      expect(actual).to eq(expected)
    end
  end
end
