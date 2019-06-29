require 'rails_helper'

RSpec.describe Api::V1::Invoices::MerchantsController do
  describe "GET #show" do
    before(:each) do
      @merchant = create(:merchant)
      @other_merchant = create(:merchant)
      @invoice = create(:invoice, merchant: @merchant)

      get "/api/v1/invoices/#{@invoice.id}/merchant"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a particular invoice's merchant" do
      actual = parse_api_1point0_response

      expected =  {
        "id" => @merchant.id.to_s,
        "type" => "merchant",
        "attributes" => {
          "id" => @merchant.id,
          "name" => @merchant.name
        }
      }
      expect(actual).to eq(expected)
    end
  end
end
