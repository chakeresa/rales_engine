desc 'Import CSV rows for all tables to development database'
namespace :csv_import do
  task run_all: [:environment,
                 'csv_import:merchants',
                 'csv_import:items',
                 'csv_import:customers',
                 'csv_import:invoices',
                 'csv_import:invoice_items',
                 'csv_import:transactions'
  ]
  # TO DO: possible refactor:
  # tables = [[merchant, Merchant, false],
  #           [item, Item, false],
  #           [customer, Customer, false],
  #           [invoice, Invoice, true],
  #           [invoice_item, InvoiceItem, true],
  #           [transaction, Transaction, true],
  # ]
  # Add service object that takes arguments of (snake_case_singular, UpperCamelCaseSingular, large_table) and does all the stuff.
  # If large_table, print only every 1000 instead of dots
  # Iterate over `tables` instead of having separate rake tasks for each table
end
