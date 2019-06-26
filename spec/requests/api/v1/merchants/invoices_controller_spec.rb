require 'rails_helper'

RSpec.describe Api::V1::Merchants::InvoicesController do
  describe "GET #index" do
    before(:each) do
      @merchant = create(:merchant)
      @i1, @i2, @i3 = create_list(:invoice, 3, merchant:@merchant)
      create_list(:merchant, 3)

      get "/api/v1/merchants/#{@merchant.id}/invoices"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoices for a particular merchant" do
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(3)

      expected_first =  {
        "id" => @i1.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => @i1.id,
          "customer_id" => @i1.customer_id,
          "merchant_id" => @i1.merchant_id
        }
      }
      expect(invoices.first).to eq(expected_first)
    end
  end
end
