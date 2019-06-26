require 'rails_helper'

RSpec.describe Api::V1::Merchants::ItemsController do
  describe "GET #index" do
    before(:each) do
      @merchant = create(:merchant)
      @i1, @i2, @i3 = create_list(:item, 3, merchant:@merchant)
      create_list(:merchant, 3)

      get "/api/v1/merchants/#{@merchant.id}/items"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all items for a particular merchant" do
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(3)

      expected_first =  {
        "id" => @i1.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @i1.id,
          "name" => @i1.name,
          "description" => @i1.description,
          "unit_price" => @i1.unit_price,
          "merchant_id" => @i1.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end
  end
end
