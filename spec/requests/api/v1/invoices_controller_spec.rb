require 'rails_helper'

RSpec.describe Api::V1::InvoicesController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_invoice = create(:invoice)
      create_list(:invoice, @count - 1)
      get '/api/v1/invoices'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoices" do
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(@count)

      expected_first =  {
        "id" => @first_invoice.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => @first_invoice.id,
          "customer_id" => @first_invoice.customer_id,
          "merchant_id" => @first_invoice.merchant_id,
          "status" => @first_invoice.status
        }
      }
      expect(invoices.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_invoice = create(:invoice)
      @other_invoices =  create_list(:invoice, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/invoices/#{@first_invoice.id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a single invoice" do
      get "/api/v1/invoices/#{@first_invoice.id}"
      invoice = parse_api_1point0_response

      expect(invoice.class).to eq(Hash)

      expected_hash =  {
        "id" => @first_invoice.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => @first_invoice.id,
          "customer_id" => @first_invoice.customer_id,
          "merchant_id" => @first_invoice.merchant_id,
          "status" => @first_invoice.status
        }
      }
      expect(invoice).to eq(expected_hash)
    end
  end
end
