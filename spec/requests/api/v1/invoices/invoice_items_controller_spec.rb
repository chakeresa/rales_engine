require 'rails_helper'

RSpec.describe Api::V1::Invoices::InvoiceItemsController do
  describe "GET #index" do
    before(:each) do
      @invoice = create(:invoice)
      @other_invoice = create(:invoice)

      @ii1, @ii2 = create_list(:invoice_item, 2, invoice: @invoice)
      @ii3 = create(:invoice_item, invoice: @invoice)
      create_list(:invoice_item, 2, invoice: @other_invoice)
      create(:invoice_item, invoice: @other_invoice)

      get "/api/v1/invoices/#{@invoice.id}/invoice_items"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoice_items for a particular invoice" do
      invoice_items = parse_api_1point0_response

      expect(invoice_items.class).to eq(Array)
      expect(invoice_items.count).to eq(3)

      expected_first =  {
        "id" => @ii1.id.to_s,
        "type" => "invoice_item",
        "attributes" => {
          "id" => @ii1.id,
          "item_id" => @ii1.item_id,
          "invoice_id" => @ii1.invoice_id,
          "quantity" => @ii1.quantity,
          "unit_price" => format_price(@ii1.unit_price)
        }
      }
      expect(invoice_items.first).to eq(expected_first)
    end
  end
end
