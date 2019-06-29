require 'rails_helper'

RSpec.describe Api::V1::Invoices::ItemsController do
  describe "GET #index" do
    before(:each) do
      @invoice = create(:invoice)
      @other_invoice = create(:invoice)

      @it1, @it2, @it3 = create_list(:item, 3)

      @ii11 = create(:invoice_item, invoice: @invoice, item: @it1)
      @ii12 = create(:invoice_item, invoice: @invoice, item: @it2)
      @ii22 = create(:invoice_item, invoice: @other_invoice, item: @it2)
      @ii23 = create(:invoice_item, invoice: @other_invoice, item: @it3)

      get "/api/v1/invoices/#{@invoice.id}/items"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all items for a particular invoice" do
      items = parse_api_1point0_response

      expect(items.class).to eq(Array)
      expect(items.count).to eq(2)

      expected_first =  {
        "id" => @it1.id.to_s,
        "type" => "item",
        "attributes" => {
          "id" => @it1.id,
          "name" => @it1.name,
          "description" => @it1.description,
          "unit_price" => format_price(@it1.unit_price),
          "merchant_id" => @it1.merchant_id
        }
      }
      expect(items.first).to eq(expected_first)
    end
  end
end
