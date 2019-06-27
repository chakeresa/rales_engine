require 'rails_helper'

RSpec.describe Api::V1::Items::InvoiceItemsController do
  describe "GET #index" do
    before(:each) do
      @item = create(:item)
      @i1, @i2, @i3 = create_list(:invoice_item, 3, item:@item)
      create_list(:item, 3)

      get "/api/v1/items/#{@item.id}/invoice_items"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoice_items for a particular item" do
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(3)

      expected_first =  {
        "id" => @i1.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @i1.id,
          "item_id" => @i1.item_id,
          "invoice_id" => @i1.invoice_id,
          "quantity" => @i1.quantity,
          "unit_price" => format_price(@i1.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end
  end
end
