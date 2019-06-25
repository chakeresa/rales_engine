require 'csv'

desc 'Import "invoice_items" CSV rows to development database'
namespace :csv_import do
  task invoice_items: :environment do
    row_count = 0
    success_count = 0
    puts "Destroying all invoice_items... ".yellow
    InvoiceItem.destroy_all
    puts "done".green
    puts "Importing invoice_items...".yellow
    CSV.foreach('./public/data/invoice_items.csv', headers: true) do |row|
      invoice_item = InvoiceItem.new(row.to_h)
      if invoice_item.save
        puts "ID #{row["id"]} done".green if row["id"].to_i % 1000 == 0
        success_count += 1
      else
        puts "ID #{row["id"]} failed".red
      end
      row_count += 1
    end
    puts "#{success_count} invoice_items created from #{row_count} CSV rows".yellow
  end
end
