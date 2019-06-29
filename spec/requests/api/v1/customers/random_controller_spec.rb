require 'rails_helper'

RSpec.describe Api::V1::Customers::RandomController do
  describe "GET #show" do
    before(:each) do
      @c1, @c2, @c3 =  create_list(:customer, 3)
      get "/api/v1/customers/random"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a random customer" do
      customer_json = parse_api_1point0_response

      expect(customer_json["attributes"]["first_name"]).to satisfy { |actual_first_name| [@c1.first_name, @c2.first_name, @c3.first_name].include?(actual_first_name) }
    end
  end
end
