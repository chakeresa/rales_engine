require 'rails_helper'

RSpec.describe Api::V1::Merchants::CustomersWithPendingInvoicesController do
  describe "GET #index" do
    before(:each) do
      @merchant = create(:merchant)
      @other_merchant = create(:merchant)

      @c1, @c2, @c3, @c4, @c5, @c6 = create_list(:customer, 6)

      @in11 = create(:invoice, merchant: @merchant, customer: @c1) # disclude (success)
      @in21 = create(:invoice, merchant: @merchant, customer: @c2) # disclude (failed + success)
      @in31 = create(:invoice, merchant: @merchant, customer: @c3) # include (failed)
      @in41 = create(:invoice, merchant: @merchant, customer: @c4) # include (no transactions)
      @in42 = create(:invoice, merchant: @merchant, customer: @c4) # include (no transactions)
      @in51 = create(:invoice, merchant: @other_merchant, customer: @c5) # disclude (other merchant / failed)

      @in61 = create(:invoice, merchant: @merchant, customer: @c6) # include (success, but in62 failed)
      @in62 = create(:invoice, merchant: @merchant, customer: @c6) # include (failed)

      @t11 = create(:transaction, invoice: @in11, result: "success")
      @t21 = create(:transaction, invoice: @in21, result: "failed")
      @t22 = create(:transaction, invoice: @in21, result: "success")
      @t31 = create(:transaction, invoice: @in31, result: "failed")
      @t51 = create(:transaction, invoice: @in51, result: "failed")

      @t61 = create(:transaction, invoice: @in61, result: "success")
      @t62 = create(:transaction, invoice: @in62, result: "failed")
    end

    it "returns http success" do
      get "/api/v1/merchants/#{@merchant.id}/customers_with_pending_invoices"
      expect(response).to have_http_status(:success)
    end

    it "outputs data for a merchant's customers that have pending invoices" do
      # GET /api/v1/merchants/:id/customers_with_pending_invoices returns a collection of customers which have pending (unpaid) invoices. A pending invoice has no transactions with a result of success. This means all transactions are failed.

      get "/api/v1/merchants/#{@merchant.id}/customers_with_pending_invoices"
      customers = parse_api_1point0_response

      expect(customers.class).to eq(Array)
      expect(customers.count).to eq(3)

      expected_first =  {
        "id" => @c3.id.to_s,
        "type" => "customer",
        "attributes" => {
          "id" => @c3.id,
          "first_name" => @c3.first_name,
          "last_name" => @c3.last_name
        }
      }
      expect(customers.first).to eq(expected_first)
    end
  end
end
