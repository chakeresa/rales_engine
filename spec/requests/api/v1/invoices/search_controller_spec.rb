require 'rails_helper'

RSpec.describe Api::V1::Invoices::SearchController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @customer_id = create(:customer).id
      @merchant_id = create(:merchant).id
      @status = "failed"
      @created_at = "2012-03-27 14:53:59 UTC"
      @updated_at = "2013-03-27 14:53:59 UTC"
      @first_invoice, @sec_invoice = create_list(:invoice, 2, customer_id: @customer_id, merchant_id: @merchant_id, status: @status, created_at: @created_at, updated_at: @updated_at)
      create_list(:invoice, @count - 2)
    end

    it "returns http success" do
      get "/api/v1/invoices/find_all?customer_id=#{@customer_id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all invoices with a particular customer_id" do
      get "/api/v1/invoices/find_all?customer_id=#{@customer_id}"
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(2)

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

    it "outputs data for all invoices with a particular merchant_id" do
      get "/api/v1/invoices/find_all?merchant_id=#{@merchant_id}"
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(2)

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

    it "outputs data for all invoices with a particular status" do
      get "/api/v1/invoices/find_all?status=#{@status}"
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(2)

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

    it "outputs data for all invoices with a particular created_at" do
      get "/api/v1/invoices/find_all?created_at=#{@created_at}"
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(2)

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

    it "outputs data for all invoices with a particular updated_at" do
      get "/api/v1/invoices/find_all?updated_at=#{@updated_at}"
      invoices = parse_api_1point0_response

      expect(invoices.class).to eq(Array)
      expect(invoices.count).to eq(2)

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
      @count = 3
      @first_invoice = create(:invoice, status: "failed", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2013-03-27 14:53:59 UTC")
      @other_invoices =  create_list(:invoice, @count - 1, created_at: "2014-03-27 14:53:59 UTC", updated_at: "2015-03-27 14:53:59 UTC")
    end

    it "returns http success" do
      get "/api/v1/invoices/find?id=#{@first_invoice.id}"
      expect(response).to have_http_status(:success)
    end

    it "finds an invoice by id" do
      invoice_resource = @other_invoices.first
      get "/api/v1/invoices/find?id=#{invoice_resource.id}"
      invoice_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_resource.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => invoice_resource.id,
          "customer_id" => invoice_resource.customer_id,
          "merchant_id" => invoice_resource.merchant_id,
          "status" => invoice_resource.status
        }
      }
      expect(invoice_json).to eq(expected_hash)
    end

    it "finds an invoice by customer_id" do
      invoice_resource = @other_invoices.first
      get "/api/v1/invoices/find?customer_id=#{invoice_resource.customer_id}"
      invoice_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_resource.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => invoice_resource.id,
          "customer_id" => invoice_resource.customer_id,
          "merchant_id" => invoice_resource.merchant_id,
          "status" => invoice_resource.status
        }
      }
      expect(invoice_json).to eq(expected_hash)
    end

    it "finds an invoice by merchant_id" do
      invoice_resource = @other_invoices.first
      get "/api/v1/invoices/find?merchant_id=#{invoice_resource.merchant_id}"
      invoice_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_resource.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => invoice_resource.id,
          "customer_id" => invoice_resource.customer_id,
          "merchant_id" => invoice_resource.merchant_id,
          "status" => invoice_resource.status
        }
      }
      expect(invoice_json).to eq(expected_hash)
    end

    it "finds an invoice by status" do
      invoice_resource = @other_invoices.first
      get "/api/v1/invoices/find?status=#{invoice_resource.status}"
      invoice_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_resource.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => invoice_resource.id,
          "customer_id" => invoice_resource.customer_id,
          "merchant_id" => invoice_resource.merchant_id,
          "status" => invoice_resource.status
        }
      }
      expect(invoice_json).to eq(expected_hash)
    end

    it "finds an invoice by created_at" do
      invoice_resource = @other_invoices.first
      get "/api/v1/invoices/find?created_at=#{invoice_resource.created_at}"
      invoice_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_resource.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => invoice_resource.id,
          "customer_id" => invoice_resource.customer_id,
          "merchant_id" => invoice_resource.merchant_id,
          "status" => invoice_resource.status
        }
      }
      expect(invoice_json).to eq(expected_hash)
    end

    it "finds an invoice by updated_at" do
      invoice_resource = @other_invoices.first
      get "/api/v1/invoices/find?updated_at=#{invoice_resource.updated_at}"
      invoice_json = parse_api_1point0_response

      expected_hash =  {
        "id" => invoice_resource.id.to_s,
        "type" => "invoice",
        "attributes" => {
          "id" => invoice_resource.id,
          "customer_id" => invoice_resource.customer_id,
          "merchant_id" => invoice_resource.merchant_id,
          "status" => invoice_resource.status
        }
      }
      expect(invoice_json).to eq(expected_hash)
    end
  end
end
