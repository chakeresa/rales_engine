require 'rails_helper'

RSpec.describe Api::V1::Customers::InvoicesController do
  describe "GET #index" do
    before(:each) do
      @customer = create(:customer)
      @i1, @i2, @i3 = create_list(:invoice, 3, customer:@customer)
      create_list(:customer, 3)

      get "/api/v1/customers/#{@customer.id}/invoices"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoices for a particular customer" do
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(3)

      expected_first =  {
        "id" => @i1.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => @i1.id,
          "customer_id" => @i1.customer_id,
          "merchant_id" => @i1.merchant_id,
          "status" => @i1.status
        }
      }
      expect(invoices.first).to eq(expected_first)
    end
  end
end
