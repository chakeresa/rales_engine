desc 'Import CSV rows for all tables to development database'
namespace :csv_import do
  task run_all: [:environment,
                 'csv_import:merchants',
                 'csv_import:items'
  ]
end
