require 'rails_helper'

RSpec.describe Api::V1::Customers::SearchController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_name = "Bob"
      @last_name = "Jones"
      @created_at = "2012-03-27 14:53:59 UTC"
      @updated_at = "2013-03-27 14:53:59 UTC"
      @first_customer, @sec_customer = create_list(:customer, 2, first_name: @first_name, last_name: @last_name, created_at: @created_at, updated_at: @updated_at)
      create_list(:customer, @count - 2)
    end

    it "returns http success" do
      get "/api/v1/customers/find_all?first_name=#{@first_name}"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all customers with a particular first_name" do
      get "/api/v1/customers/find_all?first_name=#{@first_name}"
      customers = parse_api_1point0_response

      expect(customers.class).to eq(Array)
      expect(customers.count).to eq(2)

      expected_first =  {
        "id" => @first_customer.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => @first_customer.id,
          "first_name" => @first_name,
          "last_name" => @last_name
        }
      }
      expect(customers.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 3
      @first_customer = create(:customer, first_name: "Bob", created_at: "2012-03-27 14:53:59 UTC", updated_at: "2013-03-27 14:53:59 UTC")
      @other_customers =  create_list(:customer, @count - 1, created_at: "2014-03-27 14:53:59 UTC", updated_at: "2015-03-27 14:53:59 UTC")
    end

    it "returns http success" do
      get "/api/v1/customers/find?id=#{@first_customer.id}"
      expect(response).to have_http_status(:success)
    end

    it "finds a customer by id" do
      customer_resource = @other_customers.first
      get "/api/v1/customers/find?id=#{customer_resource.id}"
      customer_json = parse_api_1point0_response

      expected_hash =  {
        "id" => customer_resource.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => customer_resource.id,
          "first_name" => customer_resource.first_name,
          "last_name" => customer_resource.last_name
        }
      }
      expect(customer_json).to eq(expected_hash)
    end

    it "finds a customer by first_name" do
      customer_resource = @other_customers.first
      get "/api/v1/customers/find?first_name=#{customer_resource.first_name}"
      customer_json = parse_api_1point0_response

      expected_hash =  {
        "id" => customer_resource.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => customer_resource.id,
          "first_name" => customer_resource.first_name,
          "last_name" => customer_resource.last_name
        }
      }
      expect(customer_json).to eq(expected_hash)
    end

    it "finds a customer by last_name" do
      customer_resource = @other_customers.first
      get "/api/v1/customers/find?last_name=#{customer_resource.last_name}"
      customer_json = parse_api_1point0_response

      expected_hash =  {
        "id" => customer_resource.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => customer_resource.id,
          "first_name" => customer_resource.first_name,
          "last_name" => customer_resource.last_name
        }
      }
      expect(customer_json).to eq(expected_hash)
    end

    it "finds a customer by created_at" do
      customer_resource = @other_customers.first
      get "/api/v1/customers/find?created_at=#{customer_resource.created_at}"
      customer_json = parse_api_1point0_response

      expected_hash =  {
        "id" => customer_resource.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => customer_resource.id,
          "first_name" => customer_resource.first_name,
          "last_name" => customer_resource.last_name
        }
      }
      expect(customer_json).to eq(expected_hash)
    end

    it "finds a customer by updated_at" do
      customer_resource = @other_customers.first
      get "/api/v1/customers/find?updated_at=#{customer_resource.updated_at}"
      customer_json = parse_api_1point0_response

      expected_hash =  {
        "id" => customer_resource.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => customer_resource.id,
          "first_name" => customer_resource.first_name,
          "last_name" => customer_resource.last_name
        }
      }
      expect(customer_json).to eq(expected_hash)
    end
  end
end
