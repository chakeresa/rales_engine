require 'rails_helper'

RSpec.describe Api::V1::InvoiceItems::ItemsController do
  describe "GET #show" do
    before(:each) do
      @item = create(:item)
      @other_item = create(:item)
      @invoice_item = create(:invoice_item, item: @item)

      get "/api/v1/invoice_items/#{@invoice_item.id}/item"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a particular invoice_item's item" do
      actual = parse_api_1point0_response

      expected =  {
        "id" => @item.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @item.id,
          "name" => @item.name,
          "description" => @item.description,
          "unit_price" => format_price(@item.unit_price),
          "merchant_id" => @item.merchant_id
        }
      }
      expect(actual).to eq(expected)
    end
  end
end
