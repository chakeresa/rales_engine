require 'rails_helper'

RSpec.describe Api::V1::Items::MerchantsController do
  describe "GET #show" do
    before(:each) do
      @merchant = create(:merchant)
      @other_merchant = create(:merchant)
      @item = create(:item, merchant: @merchant)

      get "/api/v1/items/#{@item.id}/merchant"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a particular item's merchant" do
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
