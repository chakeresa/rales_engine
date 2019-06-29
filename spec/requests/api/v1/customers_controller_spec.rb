require 'rails_helper'

RSpec.describe Api::V1::CustomersController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_customer = create(:customer)
      create_list(:customer, @count - 1)
      get '/api/v1/customers'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all customers" do
      customers = parse_api_1point0_response

      expect(customers.class).to eq(Array)
      expect(customers.count).to eq(@count)

      expected_first =  {
        "id" => @first_customer.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => @first_customer.id,
          "first_name" => @first_customer.first_name,
          "last_name" => @first_customer.last_name
        }
      }
      expect(customers.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_customer = create(:customer)
      @other_customers =  create_list(:customer, @count - 1)
    end

    it "returns http success" do
      get "/api/v1/customers/#{@first_customer.id}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a single customer" do
      get "/api/v1/customers/#{@first_customer.id}"
      customer = parse_api_1point0_response

      expect(customer.class).to eq(Hash)

      expected_hash =  {
        "id" => @first_customer.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => @first_customer.id,
          "first_name" => @first_customer.first_name,
          "last_name" => @first_customer.last_name
        }
      }
      expect(customer).to eq(expected_hash)
    end
  end
end
