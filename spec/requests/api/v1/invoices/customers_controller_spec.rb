require 'rails_helper'

RSpec.describe Api::V1::Invoices::CustomersController do
  describe "GET #show" do
    before(:each) do
      @customer = create(:customer)
      @other_customer = create(:customer)
      @invoice = create(:invoice, customer: @customer)

      get "/api/v1/invoices/#{@invoice.id}/customer"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a particular invoice's customer" do
      actual = parse_api_1point0_response

      expected =  {
        "id" => @customer.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => @customer.id,
          "first_name" => @customer.first_name,
          "last_name" => @customer.last_name
        }
      }
      expect(actual).to eq(expected)
    end
  end
end
