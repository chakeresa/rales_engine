require 'csv'

desc 'Import "invoices" CSV rows to development database'
namespace :csv_import do
  task invoices: :environment do
    row_count = 0
    success_count = 0
    puts "Destroying all invoices... ".yellow
    Invoice.destroy_all
    puts "done".green
    puts "Importing invoices...".yellow
    CSV.foreach('./public/data/invoices.csv', headers: true) do |row|
      invoice = Invoice.new(row.to_h)
      if invoice.save!
        puts "ID #{row["id"]} done".green if row["id"].to_i % 1000 == 0
        success_count += 1
      else
        puts "ID #{row["id"]} failed".red
      end
      row_count += 1
    end
    puts "#{success_count} invoices created from #{row_count} CSV rows".yellow
  end
end
