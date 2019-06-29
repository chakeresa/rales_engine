require 'rails_helper'

RSpec.describe Api::V1::Invoices::RandomController do
  describe "GET #show" do
    before(:each) do
      @i1, @i2, @i3 =  create_list(:invoice, 3)
      get "/api/v1/invoices/random"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a random invoice" do
      invoice_json = parse_api_1point0_response

      expect(invoice_json["attributes"]["customer_id"]).to satisfy { |actual_customer_id| [@i1.customer_id, @i2.customer_id, @i3.customer_id].include?(actual_customer_id) }
    end
  end
end
