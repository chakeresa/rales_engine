require 'rails_helper'

RSpec.describe CsvImporter, type: :service do
  describe "instance methods" do
    it "imports CSVs" do
      tables = [["test_merchant", Merchant, false],
               ["test_item", Item, false],
               ["test_customer", Customer, false],
               ["test_invoice", Invoice, true],
               ["test_invoice_item", InvoiceItem, true],
               ["test_transaction", Transaction, true],
      ]
      tables.each do |table|
        CsvImporter.new(table).import
      end

      expect(Merchant.count).to eq(10)
      expect(Item.count).to eq(9)
      expect(Customer.count).to eq(5)
      expect(Invoice.count).to eq(10)
      expect(InvoiceItem.count).to eq(11)
      expect(Transaction.count).to eq(12)
    end

    it "dot output doesn't error out when failed to create resources" do
      CsvImporter.new(["test_bad_merchant", Merchant, false]).import
      expect(Merchant.count).to eq(2) # 1 bad import
    end

    it "1000 output doesn't error out when failed to create resources" do
      CsvImporter.new(["test_bad_merchant", Merchant, true]).import
      expect(Merchant.count).to eq(2) # 1 bad import
    end
  end
end
