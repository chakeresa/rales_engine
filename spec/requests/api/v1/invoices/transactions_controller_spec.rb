require 'rails_helper'

RSpec.describe Api::V1::Invoices::TransactionsController do
  describe "GET #index" do
    before(:each) do
      @invoice = create(:invoice)
      @other_invoice = create(:invoice)

      @t1, @t2 = create_list(:transaction, 2, invoice: @invoice)
      @t3 = create(:transaction, invoice: @invoice, result: "failed")
      create_list(:transaction, 2, invoice: @other_invoice)
      create(:transaction, invoice: @other_invoice, result: "failed")

      get "/api/v1/invoices/#{@invoice.id}/transactions"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "outputs data for all transactions for a particular invoice" do
      transactions = parse_api_1point0_response

      expect(transactions.class).to eq(Array)
      expect(transactions.count).to eq(3)

      expected_first =  {
        "id" => @t1.id.to_s,
        "type" => "transaction",
        "attributes" => {
          "id" => @t1.id,
          "invoice_id" => @t1.invoice_id,
          "credit_card_number" => @t1.credit_card_number,
          "result" => @t1.result
        }
      }
      expect(transactions.first).to eq(expected_first)
    end
  end
end
