require 'rails_helper'

RSpec.describe Api::V1::ItemsController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_item = create(:item)
      create_list(:item, @count - 1)
      get '/api/v1/items'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all items" do
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(@count)

      expected_price = '%.2f' % (@first_item.unit_price / 100.00)

      expected_first =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => expected_price,
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_item = create(:item)
      @other_items =  create_list(:item, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/items/#{@first_item.id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a single item" do
      get "/api/v1/items/#{@first_item.id}"
      item = parse_api_1point0_response

      expect(item.class).to eq(Hash)

      expected_price = '%.2f' % (@first_item.unit_price / 100.00)

      expected_hash =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => expected_price,
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(item).to eq(expected_hash)
    end
  end
end
