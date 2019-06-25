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
end
