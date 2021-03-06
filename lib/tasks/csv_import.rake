desc 'Import CSV rows for all tables to development database'
task csv_import: :environment do
  tables = [["merchant", Merchant, false],
           ["item", Item, false],
           ["customer", Customer, false],
           ["invoice", Invoice, true],
           ["invoice_item", InvoiceItem, true],
           ["transaction", Transaction, true]
  ]
  tables.each do |table|
    CsvImporter.new(table).import
  end
end
