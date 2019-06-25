require 'csv'

desc 'Import "customers" CSV rows to development database'
namespace :csv_import do
  task customers: :environment do
    row_count = 0
    success_count = 0
    puts "Destroying all customers... ".yellow
    Customer.destroy_all
    puts "done".green
    puts "Importing customers...".yellow
    CSV.foreach('./public/data/customers.csv', headers: true) do |row|
      customer = Customer.new(row.to_h)
      if customer.save
        print ".".green
        success_count += 1
      else
        print "X".red
      end
      row_count += 1
    end
    puts "\n#{success_count} customers created from #{row_count} CSV rows".yellow
  end
end
