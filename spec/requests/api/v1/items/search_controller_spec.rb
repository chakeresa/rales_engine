require 'rails_helper'

RSpec.describe Api::V1::Items::SearchController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @name = "Bob's Invention"
      @description = "Bob's Great Invention"
      @unit_price = 19999
      @merchant = create(:merchant)
      @created_at = "2012-03-27 14:53:59 UTC"
      @updated_at = "2013-03-27 14:53:59 UTC"
      @first_item, @sec_item = create_list(:item, 2, name: @name, description: @description, unit_price: @unit_price, merchant: @merchant, created_at: @created_at, updated_at: @updated_at)
      create_list(:item, @count - 2)
    end

    it "returns http success" do
      get "/api/v1/items/find_all?name=#{@name}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all items with a particular name" do
      get "/api/v1/items/find_all?name=#{@name}"
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(2)

      expected_first =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => format_price(@first_item.unit_price),
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end

    it "outputs data for all items with a particular description" do
      get "/api/v1/items/find_all?description=#{@description}"
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(2)

      expected_first =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => format_price(@first_item.unit_price),
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end

    it "outputs data for all items with a particular unit_price" do
      get "/api/v1/items/find_all?unit_price=#{format_price(@unit_price)}"
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(2)

      expected_first =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => format_price(@first_item.unit_price),
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end

    it "outputs data for all items with a particular created_at" do
      get "/api/v1/items/find_all?created_at=#{@created_at}"
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(2)

      expected_first =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => format_price(@first_item.unit_price),
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end

    it "outputs data for all items with a particular updated_at" do
      get "/api/v1/items/find_all?updated_at=#{@updated_at}"
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(2)

      expected_first =  {
        "id" => @first_item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @first_item.id,
          "name" => @first_item.name,
          "description" => @first_item.description,
          "unit_price" => format_price(@first_item.unit_price),
          "merchant_id" => @first_item.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 3
      @first_item = create(:item, name: "Bob", description: "Bob's Great Invention", unit_price: 19999, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2013-03-27 14:53:59 UTC")
      @other_items =  create_list(:item, @count - 1, created_at: "2014-03-27 14:53:59 UTC", updated_at: "2015-03-27 14:53:59 UTC")
    end

    it "returns http success" do
      get "/api/v1/items/find?id=#{@first_item.id}"
      expect(response).to have_http_status(:success)
    end

    it "finds an item by id" do
      item_resource = @other_items.first
      get "/api/v1/items/find?id=#{item_resource.id}"
      item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => item_resource.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => item_resource.id,
          "name" => item_resource.name,
          "description" => item_resource.description,
          "unit_price" => format_price(item_resource.unit_price),
          "merchant_id" => item_resource.merchant_id
        }
      }
      expect(item_json).to eq(expected_hash)
    end

    it "finds an item by name" do
      item_resource = @other_items.first
      get "/api/v1/items/find?name=#{item_resource.name}"
      item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => item_resource.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => item_resource.id,
          "name" => item_resource.name,
          "description" => item_resource.description,
          "unit_price" => format_price(item_resource.unit_price),
          "merchant_id" => item_resource.merchant_id
        }
      }
      expect(item_json).to eq(expected_hash)
    end

    it "finds an item by description" do
      item_resource = @other_items.first
      get "/api/v1/items/find?description=#{item_resource.description}"
      item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => item_resource.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => item_resource.id,
          "name" => item_resource.name,
          "description" => item_resource.description,
          "unit_price" => format_price(item_resource.unit_price),
          "merchant_id" => item_resource.merchant_id
        }
      }
      expect(item_json).to eq(expected_hash)
    end

    it "finds an item by unit_price" do
      item_resource = @other_items.first
      get "/api/v1/items/find?unit_price=#{format_price(item_resource.unit_price)}"
      item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => item_resource.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => item_resource.id,
          "name" => item_resource.name,
          "description" => item_resource.description,
          "unit_price" => format_price(item_resource.unit_price),
          "merchant_id" => item_resource.merchant_id
        }
      }
      expect(item_json).to eq(expected_hash)
    end

    it "finds an item by created_at" do
      item_resource = @other_items.first
      get "/api/v1/items/find?created_at=#{item_resource.created_at}"
      item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => item_resource.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => item_resource.id,
          "name" => item_resource.name,
          "description" => item_resource.description,
          "unit_price" => format_price(item_resource.unit_price),
          "merchant_id" => item_resource.merchant_id
        }
      }
      expect(item_json).to eq(expected_hash)
    end

    it "finds an item by updated_at" do
      item_resource = @other_items.first
      get "/api/v1/items/find?updated_at=#{item_resource.updated_at}"
      item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => item_resource.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => item_resource.id,
          "name" => item_resource.name,
          "description" => item_resource.description,
          "unit_price" => format_price(item_resource.unit_price),
          "merchant_id" => item_resource.merchant_id
        }
      }
      expect(item_json).to eq(expected_hash)
    end
  end
end
