require 'rails_helper'

RSpec.describe Api::V1::InvoiceItems::SearchController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @item_id = create(:item).id
      @invoice_id = create(:invoice).id
      @quantity = 2
      @unit_price = 4750
      @created_at = "2012-03-27 14:53:59 UTC"
      @updated_at = "2013-03-27 14:53:59 UTC"
      @first_invoice_item, @sec_invoice_item = create_list(:invoice_item, 2, item_id: @item_id, invoice_id: @invoice_id, quantity: @quantity, unit_price: @unit_price, created_at: @created_at, updated_at: @updated_at)
      create_list(:invoice_item, @count - 2)
    end

    it "returns http success" do
      get "/api/v1/invoice_items/find_all?item_id=#{@item_id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoice_items with a particular item_id" do
      get "/api/v1/invoice_items/find_all?item_id=#{@item_id}"
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(2)

      expected_first =  {
        "id" => @first_invoice_item.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @first_invoice_item.id,
          "item_id" => @first_invoice_item.item_id,
          "invoice_id" => @first_invoice_item.invoice_id,
          "quantity" => @first_invoice_item.quantity,
          "unit_price" => format_price(@first_invoice_item.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end

    it "outputs data for all invoice_items with a particular invoice_id" do
      get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice_id}"
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(2)

      expected_first =  {
        "id" => @first_invoice_item.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @first_invoice_item.id,
          "item_id" => @first_invoice_item.item_id,
          "invoice_id" => @first_invoice_item.invoice_id,
          "quantity" => @first_invoice_item.quantity,
          "unit_price" => format_price(@first_invoice_item.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end

    it "outputs data for all invoice_items with a particular quantity" do
      get "/api/v1/invoice_items/find_all?quantity=#{@quantity}"
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(2)

      expected_first =  {
        "id" => @first_invoice_item.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @first_invoice_item.id,
          "item_id" => @first_invoice_item.item_id,
          "invoice_id" => @first_invoice_item.invoice_id,
          "quantity" => @first_invoice_item.quantity,
          "unit_price" => format_price(@first_invoice_item.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end

    it "outputs data for all invoice_items with a particular unit_price" do
      get "/api/v1/invoice_items/find_all?unit_price=#{format_price(@unit_price)}"
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(2)

      expected_first =  {
        "id" => @first_invoice_item.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @first_invoice_item.id,
          "item_id" => @first_invoice_item.item_id,
          "invoice_id" => @first_invoice_item.invoice_id,
          "quantity" => @first_invoice_item.quantity,
          "unit_price" => format_price(@first_invoice_item.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end

    it "outputs data for all invoice_items with a particular created_at" do
      get "/api/v1/invoice_items/find_all?created_at=#{@created_at}"
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(2)

      expected_first =  {
        "id" => @first_invoice_item.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @first_invoice_item.id,
          "item_id" => @first_invoice_item.item_id,
          "invoice_id" => @first_invoice_item.invoice_id,
          "quantity" => @first_invoice_item.quantity,
          "unit_price" => format_price(@first_invoice_item.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end

    it "outputs data for all invoice_items with a particular updated_at" do
      get "/api/v1/invoice_items/find_all?updated_at=#{@updated_at}"
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(2)

      expected_first =  {
        "id" => @first_invoice_item.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @first_invoice_item.id,
          "item_id" => @first_invoice_item.item_id,
          "invoice_id" => @first_invoice_item.invoice_id,
          "quantity" => @first_invoice_item.quantity,
          "unit_price" => format_price(@first_invoice_item.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 3
      @first_invoice_item = create(:invoice_item, quantity: 2, unit_price: 42, created_at: "2012-03-27 14:53:59 UTC", updated_at: "2013-03-27 14:53:59 UTC")
      @other_invoice_items =  create_list(:invoice_item, @count - 1, created_at: "2014-03-27 14:53:59 UTC", updated_at: "2015-03-27 14:53:59 UTC")
    end

    it "returns http success" do
      get "/api/v1/invoice_items/find?id=#{@first_invoice_item.id}"
      expect(response).to have_http_status(:success)
    end

    it "finds a invoice_item by id" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?id=#{invoice_item_resource.id}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end

    it "finds a invoice_item by item_id" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?item_id=#{invoice_item_resource.item_id}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end

    it "finds a invoice_item by invoice_id" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?invoice_id=#{invoice_item_resource.invoice_id}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end

    it "finds a invoice_item by quantity" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?quantity=#{invoice_item_resource.quantity}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end

    it "finds a invoice_item by unit_price" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?unit_price=#{format_price(invoice_item_resource.unit_price)}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end

    it "finds a invoice_item by created_at" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?created_at=#{invoice_item_resource.created_at}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end

    it "finds a invoice_item by updated_at" do
      invoice_item_resource = @other_invoice_items.first
      get "/api/v1/invoice_items/find?updated_at=#{invoice_item_resource.updated_at}"
      invoice_item_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_item_resource.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => invoice_item_resource.id,
          "item_id" => invoice_item_resource.item_id,
          "invoice_id" => invoice_item_resource.invoice_id,
          "quantity" => invoice_item_resource.quantity,
          "unit_price" => format_price(invoice_item_resource.unit_price)
        }
      }
      expect(invoice_item_json).to eq(expected_hash)
    end
  end
end
