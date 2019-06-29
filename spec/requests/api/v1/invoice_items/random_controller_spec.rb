require 'rails_helper'

RSpec.describe Api::V1::InvoiceItems::RandomController do
  describe "GET #show" do
    before(:each) do
      @ii1, @ii2, @ii3 =  create_list(:invoice_item, 3)
      get "/api/v1/invoice_items/random"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a random invoice_item" do
      invoice_item_json = parse_api_1point0_response

      expect(invoice_item_json["attributes"]["invoice_id"]).to satisfy { |actual_invoice_id| [@ii1.invoice_id, @ii2.invoice_id, @ii3.invoice_id].include?(actual_invoice_id) }
    end
  end
end
