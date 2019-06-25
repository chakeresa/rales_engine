require 'csv'

desc 'Import "invoices" CSV rows to development database'
namespace :csv_import do
  task invoices: :environment do
    row_count = 0
    success_count = 0
    Invoice.destroy_all
    CSV.foreach('./public/data/invoices.csv', headers: true) do |row|
      invoice = Invoice.new(row.to_h)
      if invoice.save!
        print ".".green
        success_count += 1
      else
        print "X".red
      end
      row_count += 1
    end
    require "pry"; binding.pry
    puts "\n#{success_count} invoices created from #{row_count} CSV rows".yellow
  end
end
