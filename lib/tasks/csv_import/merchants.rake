require 'csv'

desc 'Import "merchants" CSV rows to development database'
namespace :csv_import do
  task merchants: :environment do
    row_count = 0
    success_count = 0
    puts "Destroying all merchants... ".yellow
    Merchant.destroy_all
    puts "done".green
    puts "Importing merchants...".yellow
    CSV.foreach('./public/data/merchants.csv', headers: true) do |row|
      merchant = Merchant.new(row.to_h)
      if merchant.save
        print ".".green
        success_count += 1
      else
        print "X".red
      end
      row_count += 1
    end
    puts "\n#{success_count} merchants created from #{row_count} CSV rows".yellow
  end
end
