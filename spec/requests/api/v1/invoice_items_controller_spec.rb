require 'rails_helper'

RSpec.describe Api::V1::InvoiceItemsController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_invoice_item = create(:invoice_item)
      create_list(:invoice_item, @count - 1)
      get '/api/v1/invoice_items'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoice_items" do
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(@count)

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
      @count = 5
      @first_invoice_item = create(:invoice_item)
      @other_invoice_items =  create_list(:invoice_item, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/invoice_items/#{@first_invoice_item.id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a single invoice_item" do
      get "/api/v1/invoice_items/#{@first_invoice_item.id}"
      invoice_item = parse_api_1point0_response

      expect(invoice_item.class).to eq(Hash)

      expected_hash =  {
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
      expect(invoice_item).to eq(expected_hash)
    end
  end
end
